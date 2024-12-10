// main.tf
terraform {
  backend "s3" {
    bucket = ""
    key    = "/terraform.tfstate"
    region = "us-east-1"
  }
}


module "infra" {
  source             = "./module/infra"
  vpc_cidr           = var.cidr
  vpc_network_name   = var.vpc_network_name
  ig_gateway_name    = var.ig_gateway_name
  nat_gateway_name   = var.nat_gateway_name
  env                = var.env_type
  public_subnets     = var.public_subnets_cidr
  private_subnets    = var.private_subnets_cidr
  availability_zones = data.aws_availability_zones.available.names
  keyname            = var.keyname
  cluster_name       = "${var.env_type}-cluster"
}

module "aws_global" {
  depends_on = [module.infra]
  source     = "./module/global"
  env_type   = var.env_type
}

module "eks" {
  depends_on       = [module.aws_global]
  source           = "./module/k8s"
  cluster_name     = "${var.env_type}-cluster"
  k8sversion       = var.k8sversion
  cluster_role_arn = module.aws_global.eks_cluster_role
  nodes_role_arn   = module.aws_global.eks_nodes_role
  public_subnets   = module.infra.public_subnets
  private_subnets  = module.infra.private_subnets
  node_group_name  = "${var.env_type}-node-group"
  env_type         = var.env_type
  sg               = module.infra.eks-sg
  instance_type    = var.instance_type
}

module "control_host" {
  depends_on = [module.eks]

  source             = "./module/aws"
  instance_type      = "t3.micro"
  public_subnet_id   = module.infra.public_subnets
  sg                 = module.infra.sg
  availability_zones = data.aws_availability_zones.available.names[0]
  private_key        = module.infra.privatekey
  key_name           = var.keyname
  region             = var.region
  cluster-name       = "${var.env_type}-cluster"
  access_keys        = var.access_keys
  secret_key         = var.secret_keys
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "${var.env_type}-cluster-alb-ingress-role"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.eks.alb_ingress_role_arn
    }
  }
}

module "aws_load_balancer_controller" {
  source                    = "./module/helm"
  release_name              = "aws-load-balancer-controller"
  namespace                 = "kube-system"
  repository                = "https://aws.github.io/eks-charts"
  chart                     = "aws-load-balancer-controller"
  chart_version             = "1.4.1"
  eks_endpoint              = module.eks.cluster_endpoint
  eks_certificate_authority = module.eks.cluster_certificate_authority_data
  eks_cluster_name          = module.eks.cluster_name

  values = [
    yamlencode({
      clusterName = module.eks.cluster_name
      region      = var.region
      vpcId       = module.infra.id
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.alb_controller.metadata[0].name
      }
    })
  ]
}

module "cert_manager" {
  source                    = "./module/helm"
  release_name              = "cert-manager"
  namespace                 = "cert-manager"
  repository                = "https://charts.jetstack.io"
  chart                     = "cert-manager"
  chart_version             = "v1.7.1"
  eks_endpoint              = module.eks.cluster_endpoint
  eks_certificate_authority = module.eks.cluster_certificate_authority_data
  eks_cluster_name          = module.eks.cluster_name

  values = [
    yamlencode({
      installCRDs = true
      webhook     = { timeoutSeconds = 10 }
    })
  ]
}


resource "helm_release" "efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "3.0.3"

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.eks.efs_csi_role_arn
  }

  depends_on = [
    module.eks.efs_mount_target_zone_a,
    module.eks.efs_mount_target_zone_b
  ]
}

resource "kubernetes_storage_class_v1" "efs" {
  metadata {
    name = "efs"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = module.eks.efs_id
    directoryPerms   = "700"
  }

  mount_options = ["iam"]

  depends_on = [helm_release.efs_csi_driver]
}

resource "helm_release" "secrets_csi_driver" {
  name = "secrets-store-csi-driver"

  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.4.3"

  set {
    name  = "syncSecret.enabled"
    value = true
  }

  depends_on = [helm_release.efs_csi_driver]
}

resource "helm_release" "secrets_csi_driver_aws_provider" {
  name = "secrets-store-csi-driver-provider-aws"

  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"
  version    = "0.3.8"

  depends_on = [helm_release.secrets_csi_driver]
}

resource "helm_release" "argocd" {
  depends_on = [module.eks]
  name       = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.3.11"
  timeout    = 600
}

