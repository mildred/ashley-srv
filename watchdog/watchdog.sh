#!/bin/sh

wakeup_time=$(date '+%s' -d '+ 5 minutes')

log="logger -t watchdog -p daemon.info"
log_dbg=": logger -t watchdog -p daemon.debug"

$log "Uptime: $(uptime)"
$log "Waking up at $(date -d @$wakeup_time)"
echo 0 > /sys/class/rtc/rtc0/wakealarm
echo $wakeup_time > /sys/class/rtc/rtc0/wakealarm
$log_dbg </proc/driver/rtc

