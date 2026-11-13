# Easy-check Box

Easy way to spin up a "box" to check client behavior.

## How it works

Provides a recursive DNS resolver which will redirect all (or only certain…) domains
to [an HTTP/HTTPS proxy](https://www.mitmproxy.org/) running on itself.

The client will need to trust this proxy's self-signed cert,
whether by custom pre-configuration or by its own insecure logic.

(This is ± just a deployment process around `mitmproxy`, though it does provide a custom DNS plugin.)

## How to use it

Primary means is to Terraform a public server on AWS via the `aws-setup` subfolder here.
See its README for additional notes.

Otherwise you can host it directly using docker/podman/container, something like:

```
cat <<EOF > proxy.env
DNS_REDIR_DEST=192.168.0.42    # your server's IP address here

# one or none of:
DNS_REDIR_DOMAINS=
DNS_PASSTHROUGH_DOMAINS=
EOF

podman compose up
```

Otherwise you can use the `custom-dns.py` plugin here in conjunction with the sample invocation inside the `compose.yml` file as a starting point….

Once that's done point the DNS server on the device under test to the same `$DNS_REDIR_DEST` as configured (or `public_ip` output by the Terraform setup…).

---

TODO:

- [x] terraform an AWS instance
- [x] make sure only known client [no open DNS resolver!!]
- [x] ~~cloud-init~~provisioners for kickoff
- [x] privileged 53/80/443 port mapping
- [ ] avoid client 10.89.0.2 address
- [ ] dhcp server to auto-DNS??


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
