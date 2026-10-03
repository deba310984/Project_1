#!/bin/bash
# user_data.sh — bootstrap script run once at instance launch (Amazon Linux 2023).
# Installs Apache and serves a page showing which instance/AZ answered, so you
# can refresh the ALB URL and watch requests load-balance across AZs.
set -euo pipefail

dnf update -y
dnf install -y httpd
systemctl enable --now httpd

# Read instance metadata using IMDSv2 (token-based; matches http_tokens=required).
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
IID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat >/var/www/html/index.html <<HTML
<!doctype html>
<html>
  <head><title>Two-Tier Demo</title></head>
  <body style="font-family:sans-serif;max-width:40rem;margin:4rem auto">
    <h1>Two-Tier AWS Infrastructure — Project 01</h1>
    <p>Served by instance <strong>${IID}</strong></p>
    <p>Availability Zone: <strong>${AZ}</strong></p>
    <p>If you refresh and these values change, the ALB is load-balancing. ✅</p>
  </body>
</html>
HTML
