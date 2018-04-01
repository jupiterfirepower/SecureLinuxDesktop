Apparmor-profiles-extra
sudo aa-enforce firefox
iptables -I OUTPUT -o ethX -m owner --uid-owner Username -j DROP
