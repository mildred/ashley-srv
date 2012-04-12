#redo-ifchange watchdog.cron
#cp watchdog.cron /etc/cron.d/watchdog

mkdir -p /etc/watchdog.d
ln -sf $(pwd)/rwfs.sh /etc/watchdog.d/rwfs.sh

