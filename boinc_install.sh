#!/bin/bash
#Shell Script to get BOINC up and going.
# or
#What I did over winter vacation.
# by Adam

# for 64bit Linux machines

# assume the network is up, but just in case let's add a name server
# echo "nameserver 8.8.8.8" >> /etc/resolv.conf


# If arguments are empty, abort.


if [ $# -ne 1 ]; then
 echo "Run me with a hash parameter dumbass." 
 exit 0
fi

# Update Packages

#yum update -y
#yum groupinstall base development -y 

#Kill selinux cause it's a pain in the ass
setenforce 0
rm /etc/selinux/config
echo "SELINUX=disabled" >> /etc/selinux/config
echo "SELINUXTYPE=targeted" >> /etc/selinux/config

# Install BOINC

cd /usr/local/
wget http://boinc.berkeley.edu/dl/boinc_6.10.58_x86_64-pc-linux-gnu.sh
sh boinc_6.10.58_x86_64-pc-linux-gnu.sh
chown -R root.root BOINC/*
chmod -R 755 BOINC/*

# Start BOINC

cd /usr/local/BOINC/
./boinc > /dev/null &

sleep 15

# Configure Boinc to report to WGC

./run_client --allow_remote_gui_rpc --daemon
./boinccmd --project_attach www.worldcommunitygrid.com $1

# Run daemon on boot

echo "/usr/local/BOINC/boinc > /dev/null &" >> /etc/rc.d/rc.local
