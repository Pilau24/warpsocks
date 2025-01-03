#!/bin/bash

# Check if the curl package is installed
if dpkg -l | grep -q "curl"; then
    echo "curl is installed."
else
    echo "curl is not installed."
        sudo apt-get update && sudo apt-get install curl
fi

# install wgcf
curl -fsSL https://git.io/wgcf.sh | bash

# register warp account
wgcf register --accept-tos

# generate wireguard profile
wgcf generate

# move profiles to /root/
mv ./wgcf-account.toml /root/wgcf-account.toml
mv ./wgcf-profile.conf /root/wgcf-profile.conf
mv ./wireproxy.conf /root/wireproxy.conf

# download wireproxy
curl -sOL https://github.com/pufferffish/wireproxy/releases/latest/download/wireproxy_linux_amd64.tar.gz

# extract
tar -xvzf ./wireproxy_linux_amd64.tar.gz

# move to bin
mv ./wireproxy /usr/local/bin/

# move systemd service
mv ./wireproxy.service /etc/systemd/system/

# reload systemd and start wireproxy
sudo systemctl daemon-reload
sudo systemctl enable wireproxy.service
sudo systemctl start wireproxy.service