exec >&2

do-install-package bind9

redo-ifchange named.conf.local
redo-ifchange check

if ! [ -L /etc/bind/named.conf.local ]; then
  mv /etc/bind/named.conf.local /etc/bind/named.conf.local-
fi

ln -sf $(pwd)/named.conf.local /etc/bind/named.conf.local

/etc/init.d/bind9 reload
