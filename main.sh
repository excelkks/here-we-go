#!/bin/sh
domain="example.com"
user="user"
pass="pass"

apt install golang-go -y
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

caddyfile="\
:443, $domain {
  tls example@hello.com
  route {
    forward_proxy {
      basic_auth $user $pass
      hide_ip
      hide_via
      probe_resistance
    }
    reverse_proxy  https://www.baidu.com {
      header_up  Host  {upstream_hostport}
      header_up  X-Forwarded-Host  {host}
    }
  }
}"

cat <<EOF > Caddyfile
$caddyfile
EOF
./caddy start
