#! /bin/bash

: ${app_user:=admin}
: ${app_dir:=/srv/proxy}
: ${dns_script:?}
: ${compose_file:?}
: ${upstream_host:?}
: ${public_ip:?}
: ${webui_pwd:=4}

apt update

# Debian ~discontinued their `mitmproxy` package;
# it's ± easiest to use official container image.
apt install -y podman podman-compose

# HT: https://unix.stackexchange.com/questions/795036/in-podman-how-to-disable-executing-external-compose-provider-message-when-usi#comment1527343_795038
export PODMAN_COMPOSE_WARNING_LOGS=false

mkdir -p "$app_dir" "${app_dir}/data"
mv "$dns_script" "${app_dir}/data/custom-dns.py"
mv "$compose_file" "${app_dir}/compose.yml"
cat << EOF > "${app_dir}/.env"
tgtDomain=${upstream_host}
proxyIp=${public_ip}
webuiPw=${webui_pwd}
EOF

cd "$app_dir"
chown -R "${app_user}:${app_user}" .
sudo -u "$app_user" podman compose up -d
