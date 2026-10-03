#!/bin/bash
# user_data.sh — bootstrap script run once at instance launch (Amazon Linux 2023).
# Installs Apache and serves a styled status dashboard that proves the request
# was served by a specific EC2 instance in a private subnet, behind the ALB.
set -euo pipefail

dnf update -y
dnf install -y httpd
systemctl enable --now httpd

# Read instance metadata using IMDSv2 (token-based; matches http_tokens=required).
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
meta() { curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/$1"; }

IID=$(meta instance-id)
AZ=$(meta placement/availability-zone)
REGION=$(meta placement/region)
ITYPE=$(meta instance-type)
LOCALIP=$(meta local-ipv4)

cat >/var/www/html/index.html <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Two-Tier AWS Infrastructure · Live</title>
  <style>
    :root{
      --bg0:#0b1120; --bg1:#111a2e; --card:rgba(255,255,255,.04);
      --line:rgba(255,255,255,.10); --ink:#e6edf6; --muted:#8aa0bd;
      --accent:#ff9900; --accent2:#527fff; --ok:#2ec96b;
    }
    *{box-sizing:border-box}
    body{
      margin:0; min-height:100vh; color:var(--ink);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
      background:radial-gradient(1200px 600px at 20% -10%,#1b2a4a 0,transparent 60%),
                 radial-gradient(1000px 500px at 100% 0,#241533 0,transparent 55%),
                 linear-gradient(160deg,var(--bg0),var(--bg1));
      display:flex; align-items:center; justify-content:center; padding:32px;
    }
    .wrap{width:100%; max-width:720px}
    .badge{display:inline-flex; align-items:center; gap:8px; font-size:13px; font-weight:600;
      color:var(--ok); background:rgba(46,201,107,.12); border:1px solid rgba(46,201,107,.3);
      padding:6px 12px; border-radius:999px; letter-spacing:.3px}
    .dot{width:8px;height:8px;border-radius:50%;background:var(--ok);box-shadow:0 0 0 0 rgba(46,201,107,.6);
      animation:pulse 1.8s infinite}
    @keyframes pulse{0%{box-shadow:0 0 0 0 rgba(46,201,107,.5)}70%{box-shadow:0 0 0 10px rgba(46,201,107,0)}100%{box-shadow:0 0 0 0 rgba(46,201,107,0)}}
    h1{margin:16px 0 4px; font-size:30px; line-height:1.15; letter-spacing:-.5px}
    h1 span{background:linear-gradient(90deg,var(--accent),var(--accent2));-webkit-background-clip:text;background-clip:text;color:transparent}
    .sub{color:var(--muted); margin:0 0 24px; font-size:15px}
    .flow{display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin:0 0 24px; font-size:13px; color:var(--muted)}
    .flow b{color:var(--ink)}
    .node{padding:7px 12px;border:1px solid var(--line);border-radius:10px;background:var(--card)}
    .node.me{border-color:var(--accent);color:var(--ink);box-shadow:0 0 0 1px rgba(255,153,0,.25) inset}
    .arrow{color:var(--muted)}
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:12px}
    @media(max-width:520px){.grid{grid-template-columns:1fr}}
    .card{background:var(--card); border:1px solid var(--line); border-radius:14px; padding:16px 18px}
    .k{font-size:12px; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin:0 0 6px}
    .v{font-size:17px; font-weight:600; font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace; word-break:break-all}
    .pill{display:inline-block;padding:2px 10px;border-radius:999px;background:rgba(82,127,255,.15);
      border:1px solid rgba(82,127,255,.35);color:#bcd0ff;font-size:14px}
    .note{margin:22px 0 0; padding:14px 16px; border-left:3px solid var(--accent);
      background:rgba(255,153,0,.07); border-radius:0 10px 10px 0; color:#f2e3cc; font-size:14px}
    footer{margin-top:24px; display:flex; gap:8px; flex-wrap:wrap}
    .tag{font-size:12px; color:var(--muted); border:1px solid var(--line); border-radius:8px; padding:4px 10px; background:var(--card)}
  </style>
</head>
<body>
  <div class="wrap">
    <span class="badge"><span class="dot"></span>LIVE · served through the ALB</span>
    <h1>Two-Tier <span>AWS Infrastructure</span></h1>
    <p class="sub">Provisioned end-to-end with Terraform · multi-AZ · least-privilege · SSH-less</p>

    <div class="flow">
      <span class="node">🌐 Internet</span><span class="arrow">→</span>
      <span class="node">⚖️ ALB</span><span class="arrow">→</span>
      <span class="node me">🖥️ this EC2 (private)</span><span class="arrow">→</span>
      <span class="node">🗄️ RDS (private)</span>
    </div>

    <div class="grid">
      <div class="card"><p class="k">Served by instance</p><p class="v">${IID}</p></div>
      <div class="card"><p class="k">Availability Zone</p><p class="v"><span class="pill">${AZ}</span></p></div>
      <div class="card"><p class="k">Instance type</p><p class="v">${ITYPE}</p></div>
      <div class="card"><p class="k">Private IP</p><p class="v">${LOCALIP}</p></div>
    </div>

    <p class="note">🔁 <b>Refresh this page.</b> If the instance ID and AZ change, the Application Load Balancer is distributing your traffic across instances in different Availability Zones — exactly as designed.</p>

    <footer>
      <span class="tag">Region: ${REGION}</span>
      <span class="tag">Terraform</span>
      <span class="tag">VPC · 2 AZs</span>
      <span class="tag">Auto Scaling</span>
      <span class="tag">RDS MySQL</span>
      <span class="tag">IMDSv2</span>
      <span class="tag">SSM (no SSH)</span>
    </footer>
  </div>
</body>
</html>
HTML
