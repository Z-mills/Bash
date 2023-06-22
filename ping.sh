#!/bin/bash
if grep "100% packet loss" -q <<< $( ping -c 4 customdns.ddns.net); then
   ### echo "!!!SITE DOWN!!! $(date)" >> /home/dudeface/logfile.log
        echo "No connectivity at home" | mail -s "Firewall Down" dudeface.dude@dudeface.com
        echo "No connectivity at home" | mail -s "Firewall Down" 7201112233@tmomail.net
        echo "Down!"
  fi
  echo "host is up"
  exec > /tmp/part-009.log 2>&1
exit 0