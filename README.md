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
- [ ] cloud-init for kickoff


Refs:

* https://github.com/hashicorp-education/learn-terraform-provisioning/tree/cloudinit
  * via https://developer.hashicorp.com/terraform/tutorials/provision/cloud-init
* https://www.sammeechward.com/cloud-init-and-terraform-with-aws#code

