# HT: https://docs.mitmproxy.org/stable/addons/examples/#dns-simple
# and https://gist.github.com/clouedoc/818e05949717d9cfab9e709b9b05fe7a/91c2711864f39af60ffe547c8020a4a13564ca63

from ipaddress import ip_address
from mitmproxy import dns
import logging
import os

target_domains = os.getenv("MITM_DOMAIN", "ipcalf.com").split(",")
fake_ipv4_dest = os.getenv("MITM_TARGET", "127.0.0.1")

logging.info(f"Custom DNS script configured to send {" and ".join(target_domains)} to {fake_ipv4_dest}")

def dns_request(flow: dns.DNSFlow) -> None:
    q = flow.request.question
    if q.name in target_domains:
        if q.type == dns.types.A:
            logging.info(f"Spoofing A record for {q.name}")
            flow.response = flow.request.succeed([
                dns.ResourceRecord.A(
                    name=q.name,
                    ip=ip_address(fake_ipv4_dest),
                )
            ])
        elif q.type == dns.types.AAAA:
            logging.info(f"Spoofing empty AAAA set for {q.name}")
            flow.response = flow.request.succeed([])
        else:
            logging.info(f"Ignoring {q.type} query for {q.name}")
