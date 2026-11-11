#! /bin/bash

: ${app_user:=admin}
: ${app_dir:=/srv/proxy}
: ${dns_script:?}
: ${compose_file:?}

: ${public_ip:?}
: ${net_if:=ens5}
: ${domains_limited_to:=}
: ${domains_except_for:=}

apt update

# Debian ~discontinued their `mitmproxy` package;
# it's ± easiest to use official container image.
apt install -y podman podman-compose

mkdir -p "$app_dir" "${app_dir}/data"
mv "$dns_script" "${app_dir}/data/custom-dns.py"
mv "$compose_file" "${app_dir}/compose.yml"
cat << EOF > "${app_dir}/proxy.env"
DNS_REDIR_DEST=${public_ip}
DNS_REDIR_DOMAINS=${domains_limited_to}
DNS_PASSTHROUGH_DOMAINS=${domains_except_for}
EOF

# iptables -t nat -S
# nft list table nat
# HT: https://askubuntu.com/questions/444729/redirect-port-80-to-8080-and-make-it-work-on-local-machine/1119096#1119096
iptables -A PREROUTING -t nat -i $net_if -p tcp --dport 443 -j REDIRECT --to-port 8080
iptables -A PREROUTING -t nat -i $net_if -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -A PREROUTING -t nat -i $net_if -p udp --dport 53 -j REDIRECT --to-port 5353
DEBIAN_FRONTEND=noninteractive apt install -y podman iptables-persistent
iptables-save > /etc/iptables/rules.v4

cd "$app_dir"
chown -R "${app_user}:${app_user}" .
loginctl enable-linger "$app_user"
# HT: https://unix.stackexchange.com/questions/795036/in-podman-how-to-disable-executing-external-compose-provider-message-when-usi#comment1527343_795038
# HT: https://github.com/podman-container-tools/podman/issues/12983#issuecomment-1320376753
# HT: https://unix.stackexchange.com/questions/346841/why-does-sudo-i-not-set-xdg-runtime-dir-for-the-target-user
#machinectl shell admin@.host /usr/bin/podman ps
#systemd-run --user --machine=admin@.host --pipe podman ps
systemd-run --pipe --uid=$app_user --same-dir -E PODMAN_COMPOSE_WARNING_LOGS=false podman compose up -d