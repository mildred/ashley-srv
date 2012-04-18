exec >&2
redo-ifchange key
do-install-package gitolite

# mkdir -p data
# gl-setup key.pub

echo "Please configure gitolite using: dpkg-reconfigure gitolite"
echo "Data directory: /srv/git/data"
echo "Public key:     /srv/git/key.pub"
