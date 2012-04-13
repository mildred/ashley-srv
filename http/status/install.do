exec >&2

redo-ifchange httpd.conf

site_name="$(pwd | xargs basename)"

do-install-package munin
cp httpd.conf "/etc/apache2/sites-available/$site_name"
a2ensite "$site_name"
service apache2 reload

