

## Usage

You'll need:

* Terraform CLI tools (via <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>)
* AWS CLI tools (via <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>)

And then:

```
aws configure sso --profile default
ssh-add # for provisioner connection

cat << EOF > terraform.tfvars
allowed_clients = ["$(curl ipcalf.com)/32"]
#domains_limited_to = []
#domains_except_for = []
EOF
terraform init
terraform apply


PROXY_BOX=$(terraform output -raw host_ip)
SAMPLE_HOST=example.com
host $SAMPLE_HOST $PROXY_BOX
curl -H "Host: ${SAMPLE_HOST}" $PROXY_BOX
curl -v --connect-to "::${PROXY_BOX}" -k "https://${SAMPLE_HOST}"
#curl --dns-servers $PROXY_BOX -k "https://${SAMPLE_HOST}"

ssh -nNL 8081:localhost:8081 admin@${PROXY_BOX}
open "http://localhost:8081/?token=4"
```
