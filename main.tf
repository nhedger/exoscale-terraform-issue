resource "exoscale_iam_access_key" "my-access-key" {
  name = "my-access-key"
  tags = ["compute"]
}
