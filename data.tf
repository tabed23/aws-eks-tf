data "aws_eks_cluster_auth" "eks" {
  depends_on = [module.eks]
  name       = module.eks.eks_cluster.name
}
data "aws_availability_zones" "available" {
  state = "available"
}