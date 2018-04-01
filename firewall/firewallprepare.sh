#!/bin/bash

apt-get -y install net-tools
apt-get -y install xtables-addons-common
apt-get -y install xtables-addons-dkms
apt-get -y install ipset
apt-get -y install geoip-bin geoip-database

# Install necessary packages
sudo apt-get unzip
sudo apt-get install libtext-csv-xs-perl
# Create database location
sudo mkdir /usr/share/xt_geoip
# Download the database file and convert
/usr/lib/xtables-addons/xt_geoip_dl
sudo /usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv

touch /etc/network/if-pre-up.d/iptables
echo "#!/bin/bash" > /etc/network/if-pre-up.d/iptables
echo "iptables-restore < /etc/iptables/rules.v4" >> /etc/network/if-pre-up.d/iptables
echo "exit 0" >> /etc/network/if-pre-up.d/iptables

chmod +x /etc/network/if-pre-up.d/iptables

touch /etc/network/if-post-down.d/iptables
echo "#!/bin/bash" > /etc/network/if-post-down.d/iptables
echo " iptables-save -c > /etc/iptables/rules.v4" >> /etc/network/if-post-down.d/iptables
echo " if [ -f /etc/iptables/rules.v4 ]; then" >> /etc/network/if-post-down.d/iptables
echo " 	iptables-restore < /etc/iptables/rules.v4" >> /etc/network/if-post-down.d/iptables
echo " fi" >> /etc/network/if-post-down.d/iptables
echo "exit 0" >> /etc/network/if-post-down.d/iptables

chmod +x /etc/network/if-post-down.d/iptables
