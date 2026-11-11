

## Usage

You'll need:

* Terraform CLI tools (via <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>)
* AWS CLI tools (via <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>)

And then:

```
terraform init

aws configure sso --profile default

cat << EOF > terraform.tfvars
allowed_clients = ["$(curl ipcalf.com)/32"]
#domains_limited_to = []
#domains_except_for = []
EOF

terraform apply


PROXY_BOX=$(terraform output -raw host_ip)
host -p 5353 ipcalf.com $PROXY_BOX
curl ${PROXY_BOX}:8080
curl -k https://${PROXY_BOX}:8080

ssh -nNL 8081:localhost:8081 admin@${PROXY_BOX}
open "http://localhost:8081/?token=4"
```
