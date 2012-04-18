exec >&2
redo-ifchange key
do-install-package gitolite

# mkdir -p data
# gl-setup key.pub

sed -ri 's/^AcceptEnv/# AcceptEnv/' /etc/ssh/sshd_config
service ssh reload

# echo "Please configure gitolite using: dpkg-reconfigure gitolite"
# echo "Data directory: /srv/git/data"
# echo "Public key:     /srv/git/key.pub"

# Manually execute the configure steps
# Inspired from /var/lib/dpkg/info/gitolite.postinst

GITUSER="git"
GITDIR=$PWD/data
ADMINKEY=$PWD/key.pub

if ! getent passwd "$GITUSER" >/dev/null; then
  adduser --quiet --system --home "$GITDIR" --shell /bin/bash \
    --no-create-home --gecos 'git repository hosting' \
    --group "$GITUSER"
fi

if [ ! -r "$GITDIR/.gitolite.rc" ]; then

  if [ ! -d "$GITDIR" ]; then
    mkdir -p "$GITDIR"
    chown "$GITUSER":"$GITUSER" "$GITDIR"
  fi

  # create admin repository
  tmpdir="$(mktemp -d)"
  cat "$ADMINKEY" > "$tmpdir/admin.pub"
  chown -R "$GITUSER" "$tmpdir"
  su -c "gl-setup -q '$tmpdir/admin.pub'" "$GITUSER"
  rm -r "$tmpdir"

else
  echo "gitolite seems to be already set up in $GITDIR, doing nothing." 1>&2
fi
