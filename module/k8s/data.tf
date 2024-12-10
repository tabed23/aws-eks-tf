data "aws_eks_cluster" "eks" {
  name       = var.cluster_name
  depends_on = [aws_eks_cluster.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name       = var.cluster_name
  depends_on = [aws_eks_cluster.eks]
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
