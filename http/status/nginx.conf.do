. ../vhost.sh

cat >"$3" <<EOF

server {
  listen 80;
  listen [::]:80;
  server_name $vhost.$domain;
  root "/var/cache/munin/www";
}

EOF

