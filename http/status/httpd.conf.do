redo-ifchange ../domain

cat >"$3" <<EOF

# Should be present at least once
# NameVirtualHost *:80

<VirtualHost *:80>
  ServerName status.$(cat ../domain)
  DocumentRoot /var/cache/munin/www

  <Location />
    Order allow,deny
    Allow from all

    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresDefault M310
    </IfModule>
  </Location>

</VirtualHost>

EOF
