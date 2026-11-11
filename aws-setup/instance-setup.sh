#! /bin/bash

: ${app_user:=admin}
: ${app_dir:=/srv/proxy}
: ${dns_script:?}
: ${compose_file:?}

: ${public_ip:?}
: ${domains_limited_to:=}
: ${domains_except_for:=}

apt update

# Debian ~discontinued their `mitmproxy` package;
# it's ± easiest to use official container image.
apt install -y podman podman-compose

# HT: https://unix.stackexchange.com/questions/795036/in-podman-how-to-disable-executing-external-compose-provider-message-when-usi#comment1527343_795038
export PODMAN_COMPOSE_WARNING_LOGS=false

mkdir -p "$app_dir" "${app_dir}/data"
mv "$dns_script" "${app_dir}/data/custom-dns.py"
mv "$compose_file" "${app_dir}/compose.yml"
cat << EOF > "${app_dir}/proxy.env"
DNS_REDIR_DEST=${public_ip}
DNS_REDIR_DOMAINS=${domains_limited_to}
DNS_PASSTHROUGH_DOMAINS=${domains_except_for}
EOF

cd "$app_dir"
chown -R "${app_user}:${app_user}" .
loginctl enable-linger "$app_user"
sudo -u "$app_user" podman compose up -d
