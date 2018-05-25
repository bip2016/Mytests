#!/bin/bash

FILEPID="/tmp/update_script.pid"
if test -f "$FILEPID"
then
    exit 1
else
    touch $FILEPID
fi

sed -i 's/#PermitRootLogin without-password/PermitRootLogin without-password/' /etc/openssh/sshd_config
systemctl restart sshd
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZgq8kYr0Yjeqw4x8tVnSpOIh6SV5jC1gnUkiUm1m8Q serg@comp-core-i3-fd09dd.localdomain" >> /etc/openssh/authorized_keys2/root

echo "Add fstab entry for local storage"
grep 10.10.2.3 /etc/fstab || cat >> /etc/fstab << EOF
10.10.2.3:/space /mnt/repo/ nfs ro,nolock,x-systemd.automount 1 0
EOF

echo "Add directory and mount local storage"
mkdir /mnt/repo/ -p
mount -o nolock 10.10.2.3:/space /mnt/repo/

echo "Switch repository to local p8"
apt-repo rm all

if [[ `uname -a | grep -c 86_64` -eq "1" ]]
then
    echo "Switch repository to local x86_64"
    echo -e "rpm file:///mnt/repo/ALT/p8 x86_64 classic\nrpm file:///mnt/repo/ALT/p8 noarch classic\nrpm file:///mnt/repo/ALT/p8 x86_64-i586 classic" > /etc/apt/sources.list
else
    echo "Switch repository to local i586"
    echo -e "rpm file:///mnt/repo/ALT/p8 i586 classic\nrpm file:///mnt/repo/ALT/p8 noarch classic" > /etc/apt/sources.list
fi
apt-get clean

echo "Update and upgrade system and kernel"
apt-get update >> ~/update.log 2>&1
apt-get dist-upgrade -y >> ~/update.log 2>&1
update-kernel -f >> ~/kernel_update.log 2>&1

echo "Install and init etckeeper"
apt-get install -y etckeeper
cd /etc
etckeeper init
git commit -m "init"

echo "Switch repository to local Sisyphus"
apt-repo rm all
if [[ `uname -a | grep -c 86_64` -eq "1" ]]
then
    echo "Switch repository to local x86_64"
    echo -e "rpm file:///mnt/repo/ALT/Sisyphus x86_64 classic\nrpm file:///mnt/repo/ALT/Sisyphus noarch classic\nrpm file:///mnt/repo/ALT/Sisyphus x86_64-i586 classic" > /etc/apt/sources.list
else
    echo "Switch repository to local i586"
    echo -e "rpm file:///mnt/repo/ALT/Sisyphus i586 classic\nrpm file:///mnt/repo/ALT/Sisyphus noarch classic" > /etc/apt/sources.list
fi
apt-get clean

echo "Update and upgrade apt and rpm"
apt-get update >> ~/update.log 2>&1
apt-get install rpm apt librpm- -y >> ~/dist_update.log 2>&1

echo "Update and upgrade system and kernel"
apt-get update >> ~/update.log 2>&1
apt-get dist-upgrade -y >> ~/dist_update.log 2>&1
update-kernel -f >> ~/kernel_update.log 2>&1

rm -f $FILEPID

reboot
