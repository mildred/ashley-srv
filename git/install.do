exec >&2
redo-ifchange key

sed -ri 's/^AcceptEnv/# AcceptEnv/' /etc/ssh/sshd_config
service ssh reload

if ! [ -d gitolite ]; then
  echo "Missing submodule gitolite"
  exit 1
fi

gitolite/install -ln $PWD/../scripts/bin
gitolite=$PWD/gitolite/src/gitolite

GITUSER="git"
GITDIR=$PWD/data
ADMINKEY=$PWD/key.pub

if ! getent passwd "$GITUSER" >/dev/null; then
  adduser --quiet --system --home "$GITDIR" --shell /bin/bash \
    --no-create-home --gecos 'git repository hosting' \
    --group "$GITUSER"
fi

if [ ! -d "$GITDIR" ]; then
  mkdir -p "$GITDIR"
  chown "$GITUSER":"$GITUSER" "$GITDIR"
fi

if [ ! -r "$GITDIR/.gitolite.rc" ]; then
  su -c "$gitolite setup -pk $ADMINKEY" $GITUSER
else
  echo "gitolite seems to be already set up in $GITDIR, doing nothing." 1>&2
fi
