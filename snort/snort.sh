#!/bin/bash

sudo -g ginet wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
sudo -g ginet wget https://www.snort.org/downloads/snort/snort-2.9.9.0.tar.gz
sudo -g ginet wget https://www.snort.org/rules/community

sudo apt-get install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev

tar xvfz daq-2.0.6.tar.gz

cd daq-2.0.6
./configure && make && sudo make install

cd ..

tar xvfz snort-2.9.9.0.tar.gz

cd snort-2.9.9.0
./configure --enable-sourcefire && make && sudo make install

ldconfig

cd ..

tar -xvfz community.tar.gz -C /etc/snort/rules

#ln -s /usr/local/bin/snort /usr/sbin/snort

#snort -V

mkdir -p /etc/snort
mkdir -p /etc/snort/preproc_rules
mkdir -p /etc/snort/rules
mkdir -p /etc/snort/so_rules
mkdir -p /var/log/snort
mkdir -p /usr/local/lib/snort_dynamicrules

touch /etc/snort/rules/white_list.rules
touch /etc/snort/rules/black_list.rules

chmod -R 5775 /etc/snort/
chmod -R 5775 /var/log/snort/
chmod -R 5775 /usr/local/lib/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules/

cd snort-2.9.9.0/etc
cp -avr *.conf *.config *.map *.dtd /etc/snort/
cd ..
cp -avr src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/*  /usr/local/lib/snort_dynamicpreprocessor/

sed -i -e 's/ipvar HOME_NET any/ipvar HOME_NET 192.168.0.0\/24/1' /etc/snort/snort.conf
sed -i -e 's/var RULE_PATH ..\/rules/var RULE_PATH \/etc\/snort\/rules/1' /etc/snort/snort.conf
sed -i -e 's/var SO_RULE_PATH ..\/so_rules/var SO_RULE_PATH \/etc\/snort\/so_rules/1' /etc/snort/snort.conf
sed -i -e 's/var PREPROC_RULE_PATH ..\/preproc_rules/var PREPROC_RULE_PATH \/etc\/snort\/preproc_rules/1' /etc/snort/snort.conf
sed -i -e 's/var WHITE_LIST_PATH ..\/rules/var WHITE_LIST_PATH \/etc\/snort\/rules/1' /etc/snort/snort.conf
sed -i -e 's/var BLACK_LIST_PATH ..\/rules/var BLACK_LIST_PATH \/etc\/snort\/rules/1' /etc/snort/snort.conf

cd ..
tar xvfz $PWD/snortrules-snapshot-2990.tar.gz
#cd snortrules-snapshot-2990/ 
cp -avr rules /etc/snort/
cp -avr so_rules /etc/snort/
cp -avr preproc_rules /etc/snort/

cd ..

#netdev=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | sed -nr '1s/^([^: ]+).*/\1/p')
netdev=$(ls /sys/class/net | sed -nr '1s/^([^ ]+).*/\1/p')

/usr/local/bin/snort -T -i $netdev -c /etc/snort/snort.conf

export LD_LIBRARY_PATH=/usr/local/lib

echo "LD_LIBRARY_PATH=\"/usr/local/lib\"" >> /etc/environment
echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.bashrc

touch /lib/systemd/system/snort.service
echo "/lib/systemd/system/snort.service created."

echo "[Unit]" > /lib/systemd/system/snort.service
echo "Description=Snort NIDS Daemon" >> /lib/systemd/system/snort.service
echo "After=syslog.target network.target" >> /lib/systemd/system/snort.service
echo "[Service]" >> /lib/systemd/system/snort.service
echo "TimeoutStartSec=0">> /lib/systemd/system/snort.service
echo "Type=simple">> /lib/systemd/system/snort.service
echo "PIDFile=/run/snort_$netdev.pid">> /lib/systemd/system/snort.service
echo "ExecStart=/usr/local/bin/snort -q -c /etc/snort/snort.conf -l /var/log/snort -i $netdev -D" >> /lib/systemd/system/snort.service
echo "[Install]">> /lib/systemd/system/snort.service
echo "WantedBy=multi-user.target">> /lib/systemd/system/snort.service

echo "systemctl enable snort"
systemctl enable snort
echo "sudo systemctl start snort"
sudo systemctl start snort
echo "systemctl status snort"
systemctl status snort
