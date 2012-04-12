#!/bin/bash

set -e

log(){
  logger -s -t watchdog.rwfs -p daemon.$1 "$2"
}

# log notice "Checking filesystems are read-write"

for d in /tmp /var/tmp; do
  if ! touch $d/.watchdogfile; then
    log error "Could not write to $d"
    exit 1
  fi
  if ! [[ -f $d/.watchdogfile ]]; then
    log error "Could not read from $d"
    exit 1
  fi
  if ! rm $d/.watchdogfile; then
    log error "Could not delete from $d"
    exit 1
  fi
done

# log notice "Read-Write test passed"

exit 0

case $1 in

#  repair)
#    logger -t watchdog-rwfs "Repair: reboot"
#    exit -1
#    ;;

  test|*)
    if [[ rw == "$(awk '{ if ($2 == "/" && $1 != "rootfs") { print substr($4, 0, 2); } }' /etc/mtab)" ]]; then
      exit 0
    else
      logger -t watchdog-rwfs "mtab:"
      logger -t watchdog-rwfs </etc/mtab
      exit -1
    fi
    ;;

esac

logger -t watchdog-rwfs "Invalid arguments: $@"
exit -1
