resource "aws_ssm_parameter" "ssm_parameter_01" {
  name  = "important-key"
  type  = "String"
  value = "some new value"
}
