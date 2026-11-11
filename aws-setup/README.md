

## Usage

You'll need:

* Terraform CLI tools (via <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>)
* AWS CLI tools (via <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>)

And then:

```
terraform init

aws configure sso --profile default

cat << EOF > terraform.tfvars
upstream_host = "ipcalf.com"
allowed_clients = ["$(curl ipcalf.com)/32"]
EOF

terraform apply


PROXY_BOX=$(terraform output -raw host_ip)
host -p 5353 ipcalf.com $PROXY_BOX
curl ${PROXY_BOX}:8080
```
