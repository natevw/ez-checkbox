#! /bin/sh

tgtDomain=ipcalf.com
runner=container  # or docker/podman

"$runner" kill mitm; sleep 1

mkdir -p ~/.mitmproxy
cp ./custom-dns.py ~/.mitmproxy/custom-dns.py

mitmPw=$(uuidgen)
"$runner" run -d --name mitm --rm \
  -v ~/.mitmproxy:/home/mitmproxy/.mitmproxy \
  -p 8080:8080 -p 127.0.0.1:8081:8081 \
  -e DNS_REDIR_DOMAINS=$tgtDomain \
  -e DNS_REDIR_DEST___TODO=$mitmIp \  # we don't know it yet! :-/
  docker.io/mitmproxy/mitmproxy mitmweb \
  --web-host 0.0.0.0 \
  --set web_password=${mitmPw} \
  -s /home/mitmproxy/.mitmproxy/custom-dns.py \
  --mode=reverse:https://${tgtDomain} \
  --mode=dns

mitmIp=$("$runner" inspect mitm | jq -r '.[0].networks[0].ipv4Address' | cut -d / -f 1)
open "http://${mitmIp}:8081?token=${mitmPw}"
#open "http://${mitmIp}:8081/#/flows?e=true"
dig @$mitmIp google.com
dig @$mitmIp ipcalf.com
