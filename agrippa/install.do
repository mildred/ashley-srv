sed -i -r "/^\S+\s+${PWD//\//\\/}\s+/d" /etc/fstab

cat >>/etc/fstab <<EOF
admin@agrippa.local:/ffp/../Ashley /srv/agrippa fuse.sshfs nonempty,reconnect,idmap=user,ServerAliveInterval=15 0 0
EOF

mount $PWD
