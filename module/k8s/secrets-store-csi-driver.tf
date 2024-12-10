data "aws_iam_policy_document" "secrets_document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "secrets_role" {
  name               = replace("${var.cluster_name}-secrets-role", "[^a-zA-Z0-9+=,.@_-]", "-")
  assume_role_policy = data.aws_iam_policy_document.secrets_document.json
}

resource "aws_iam_policy" "secrets_policy" {
  name = replace("${var.cluster_name}-secrets-policy", "[^a-zA-Z0-9+=,.@_-]", "-")

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets" {
  policy_arn = aws_iam_policy.secrets_policy.arn
  role       = aws_iam_role.secrets_role.name
}
