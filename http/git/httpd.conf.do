redo-ifchange ../domain

docroot=/usr/share/gitweb

cat >"$3" <<EOF

# Should be present at least once
# NameVirtualHost *:80

<VirtualHost *:80>
  ServerName git.$(cat ../domain)
  DocumentRoot $docroot

  <Directory $docroot>
    Allow from all
    AllowOverride all
    Order allow,deny
    Options ExecCGI
    <Files gitweb.cgi>
      SetHandler cgi-script
    </Files>
  </Directory>

  DirectoryIndex gitweb.cgi
  SetEnv  GITWEB_CONFIG  /etc/gitweb.conf
  # SuexecUserGroup gitolite gitolite

</VirtualHost>

EOF
