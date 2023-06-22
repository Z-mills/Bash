#!/bin/bash

# Check if running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root or using sudo"
  exit 1
fi

# Display system information
echo "System information:"
echo "-------------------"
uname -a
echo ""
cat /etc/*release*
echo ""

# Check for security updates
echo "Security updates:"
echo "-----------------"
yum check-update --security

# Check for open network ports
echo "Open network ports:"
echo "--------------------"
netstat -tulpn

# Check for suspicious processes
echo "Suspicious processes:"
echo "---------------------"
ps aux | awk '$3 >= 10.0 || $4 >= 10.0 { print }'

# Check for root-owned files in home directories
echo "Root-owned files in home directories:"
echo "------------------------------------"
find /home -type f -user root

# Check for world-writable files
echo "World-writable files:"
echo "---------------------"
find / -xdev -type f -perm -0002

# Check for unusual setuid and setgid files
echo "Unusual setuid and setgid files:"
echo "--------------------------------"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -print

# Check for unauthorized SSH keys
echo "Unauthorized SSH keys:"
echo "----------------------"
grep ssh-rsa /home/*/.ssh/authorized_keys
