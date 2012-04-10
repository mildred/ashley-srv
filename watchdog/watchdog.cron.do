cat >"$3" <<EOF

PATH=$PATH

* * * * * root $(pwd)/watchdog.sh

EOF

chmod 0644 "$3"
