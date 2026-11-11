# Easy-check Box

Easy way to spin up a "box" to check client behavior.

## How it works

Provides a recursive DNS resolver which will redirect certain domains
to a TLS proxy running on itself.

The client will need to trust this proxy's self-signed cert,
whether by custom pre-configuration or by its own insecure logic.


---

TODO:

- [x] terraform an AWS instance
- [x] make sure only known client [no open DNS resolver!!]
- [x] ~~cloud-init~~provisioners for kickoff
- [x] privileged 53/80/443 port mapping
- [x] avoid client 10.89.0.2 address


Refs:

* https://github.com/containers/podman-compose/blob/main/docs/Extensions.md#podman-specific-network-modes
* https://github.com/eriksjolund/podman-networking-docs#source-address-preserved
* https://docs.podman.io/en/v5.4.2/markdown/podman-network.1.html
* https://stackoverflow.com/questions/75427655/how-to-podman-rootless-expose-containers-ports-to-the-outside-and-see-real-clie
  * via https://old.reddit.com/r/podman/comments/14lls6v/same_ip_address_for_all_incoming_connections_in/jpyei29/
* https://oneuptime.com/blog/post/2026-03-18-bind-privileged-ports-rootless-podman/view#method-3-use-port-forwarding-with-iptables
* https://github.com/hashicorp-education/learn-terraform-provisioning/tree/cloudinit
  * via https://developer.hashicorp.com/terraform/tutorials/provision/cloud-init
* https://www.sammeechward.com/cloud-init-and-terraform-with-aws#code
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
  * via https://stackoverflow.com/questions/47614905/how-can-i-add-linux-bash-script-file-into-terraform-code/47624273#47624273
* https://serverfault.com/questions/1085968/run-a-script-via-cloud-init
* https://developer.hashicorp.com/terraform/language/provisioners#add-a-provisioner-to-your-resource
  * via https://stackoverflow.com/questions/62101009/terraform-copy-upload-files-to-aws-ec2-instance/62101890#62101890
