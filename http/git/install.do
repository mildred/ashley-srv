exec >&2

redo-ifchange httpd.conf nginx.conf

site_name="$(pwd | xargs basename)"
projectroot=/srv/git/data/repositories
projectlist=/srv/git/data/projects.list

do-install-package gitweb daemontools daemontools-run libcgi-fast-perl fcgiwrap

# Configure gitweb
sed -ri 's/^\#?(\$projectroot\s*=\s*).*;/\1"'"${projectroot//\//\\/}"'";/' /etc/gitweb.conf
sed -ri 's/^\#?(\$projects_list\s*=\s*).*;/\1"'"${projectlist//\//\\/}"'";/' /etc/gitweb.conf

# Install gitweb fastcgi
svc -t gitweb
update-service --add $(pwd)/gitweb-fastcgi gitweb

# Install site configuration
cp httpd.conf "/etc/apache2/sites-available/$site_name"
cp nginx.conf "/etc/nginx/sites-available/$site_name"

# Enable nginx site
ln -sf "../sites-available/$site_name" "/etc/nginx/sites-enabled/$site_name"
service nginx reload


# ln -sf /usr/share/gitweb /var/www/gitweb
# a2enmod suexec
# a2ensite "$site_name"
# service apache2 reload

