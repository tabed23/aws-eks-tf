resource "helm_release" "app" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  timeout          = 600

  values = var.values
}