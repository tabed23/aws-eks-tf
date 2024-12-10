output "eks_cluster_role" {
  value = aws_iam_role.eks_cluster
}

output "eks_nodes_role" {
  value = aws_iam_role.nodes
}