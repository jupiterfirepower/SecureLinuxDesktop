sudo apt-get -y install libcarp-clan-perl libdate-calc-perl \
libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl \
libunix-syslog-perl libbit-vector-perl gcc wget

wget http://cipherdyne.org/psad/download/psad-2.4.4.tar.gz

tar xvf psad-2.4.4.tar.gz
cd psad-2.4.4

#Debian / Ubuntu (sudo)
sudo ./install.pl

sudo apt-get install fwsnort


#iptables -A INPUT -i lo -j ACCEPT
#iptables -A INPUT -p icmp -m limit --limit 1/sec -j ACCEPT
#iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A INPUT -j LOG --log-level warn
#iptables -A INPUT -f -j DROP
#iptables -A INPUT -m state --state INVALID -j DROP
#iptables -A INPUT -j DROP
#iptables -A FORWARD -j DROP


# Debian / Ubuntu / sudo
sudo ln -s /bin/true /bin/mail

#sudo -i
#wget http://bodhizazen.net/aa-profiles/bodhizazen/ubuntu-10.04/usr.sbin.psad
#wget http://bodhizazen.net/aa-profiles/bodhizazen/ubuntu-10.04/usr.sbin.fwsnort
#wget http://bodhizazen.net/aa-profiles/bodhizazen/ubuntu-10.04/etc.fwsnort.fwsnort.sh
#aa-enforce usr.sbin.psad usr.sbin.fwsnort etc.fwsnort.fwsnort.sh
#exit

service psad start
service psad stop
service psad restart

psad --sig-update
psad -H

sudo fwsnort --update-rules
sudo fwsnort

sudo /etc/fwsnort/fwsnort.sh
#/etc/rc.local

sed -i -e 's/[6789]/6789/g' /var/lib/fwsnort/fwsnort.save
iptables-restore < /var/lib/fwsnort/fwsnort.save
iptables-save > /etc/iptables/rules.v4



