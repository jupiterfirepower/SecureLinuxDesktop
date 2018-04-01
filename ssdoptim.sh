sed -i -e 's/errors=remount-ro 0       1/nodiratime,noatime,errors=remount-ro 0       1/g' /etc/fstab
sudo mv -v /etc/cron.weekly/fstrim /etc/cron.daily
#sudo mv -v /etc/cron.daily/fstrim /etc/cron.weekly/fstrim
sudo fstrim -v /
#sudo fstrim -v /home
sed -i -e 's/quiet splash/elevator=deadline quiet splash/g' /etc/default/grub
#Disable hibernation (suspend-to-disk, only necessary in Linux Mint)
sudo mv -v /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla /
#Disable suspend (suspend-to-ram)
#sudo touch /etc/polkit-1/localauthority/90-mandatory.d/disable-suspend.pkla
sudo update-grub
