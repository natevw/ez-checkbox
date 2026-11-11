# HT: https://docs.mitmproxy.org/stable/addons/examples/#dns-simple
# and https://gist.github.com/clouedoc/818e05949717d9cfab9e709b9b05fe7a/91c2711864f39af60ffe547c8020a4a13564ca63

from ipaddress import ip_address
from mitmproxy import dns
import logging
import os

def _spl(s):
    """Splits a string into a list based on comma/whitespace"""
    # NOTE: splitting on `None` (whitespace) is special:
    # automatically removes empty parts from the result!
    return s.replace(',', ' ').split()

redir_dest = os.getenv("DNS_REDIR_DEST", "127.0.0.1")
target_domains = _spl(os.getenv("DNS_REDIR_DOMAINS", ""))
nontarget_domains = _spl(os.getenv("DNS_PASSTHROUGH_DOMAINS", ""))

if len(target_domains):
    logging.info(f"Custom DNS script configured to redirect {" and ".join(target_domains)} to {redir_dest}")
elif len(nontarget_domains):
    logging.info(f"Custom DNS script configured to redirect everything EXCEPT {" and ".join(target_domains)} to {redir_dest}")
else:
    logging.info(f"Custom DNS script configured to redirect EVERYTHING to {redir_dest}")

def dns_request(flow: dns.DNSFlow) -> None:
    q = flow.request.question
    
    if len(target_domains):
        should_redirect = q.name in target_domains
    elif len(nontarget_domains):
        should_redirect = q.name not in nontarget_domains
    else:
        should_redirect = True
    
    if should_redirect:
        if q.type == dns.types.A:
            logging.info(f"Spoofing A record for {q.name}")
            flow.response = flow.request.succeed([
                dns.ResourceRecord.A(
                    name=q.name,
                    ip=ip_address(redir_dest),
                )
            ])
        elif q.type == dns.types.AAAA:
            logging.info(f"Spoofing empty AAAA set for {q.name}")
            flow.response = flow.request.succeed([])
        else:
            logging.info(f"Ignoring {q.type} query for {q.name}")
