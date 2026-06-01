#!/bin/sh
cd /root/app/

./tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
./tailscale up --auth-key=${TAILSCALE_AUTHKEY} --hostname=fly-app

jpm -l janet main.janet;
