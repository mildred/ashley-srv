. ../vhost.sh

docroot=/usr/share/gitweb

cat >"$3" <<EOF

server {
  listen 80;
  listen [::]:80;
  server_name $vhost.$domain;
  root "$docroot";

  location / {
    # fastcgi_pass  unix:$PWD/gitweb-fastcgi/fastcgi.sock;
    fastcgi_pass  127.0.0.1:9002;
    fastcgi_index index.cgi;

    fastcgi_param SCRIPT_FILENAME $docroot\$fastcgi_script_name;
    fastcgi_param QUERY_STRING    \$query_string;
    fastcgi_param REQUEST_METHOD  \$request_method;
    fastcgi_param CONTENT_TYPE    \$content_type;
    fastcgi_param CONTENT_LENGTH  \$content_length;
  }

  location /static {
    root "$docroot";
  }
}

EOF

