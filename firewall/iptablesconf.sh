#!/bin/bash
#iptables controls five different tables: filter, nat, mangle, raw and security. 

#0 — echo reply (echo-ответ, пинг)
#3 — destination unreachable (адресат недосягаем)
#4 — source quench (подавление источника, просьба посылать пакеты медленнее)
#5 — redirect (редирект)
#8 — echo request (echo-запрос, пинг)
#9 — router advertisement (объявление маршрутизатора)
#10 — router solicitation (ходатайство маршрутизатора)
#11 — time-to-live exceeded (истечение срока жизни пакета)
#12 — IP header bad (неправильный IPзаголовок пакета)
#13 — timestamp request (запрос значения счетчика времени)
#14 — timestamp reply (ответ на запрос значения счетчика времени)
#15 — information request (запрос информации)
#16 — information reply (ответ на запрос информации)
#17 — address mask request (запрос маски сети)
#18 — address mask reply (ответ на запрос маски сети)

# KERNEL PARAMETER CONFIGURATION

# PREVENT YOU SYSTEM FROM ANSWERING ICMP ECHO REQUESTS
#echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

# DROP ICMP ECHO-REQUEST MESSAGES SENT TO BROADCAST OR MULTICAST ADDRESSES
#echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# DONT ACCEPT ICMP REDIRECT MESSAGES
#echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects

# DONT SEND ICMP REDIRECT MESSAGES
#echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects

# DROP SOURCE ROUTED PACKETS
#echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

# ENABLE TCP SYN COOKIE PROTECTION FROM SYN FLOODS
#echo 1 > /proc/sys/net/ipv4/tcp_syncookies

# ENABLE SOURCE ADDRESS SPOOFING PROTECTION
#echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter

# LOG PACKETS WITH IMPOSSIBLE ADDRESSES (DUE TO WRONG ROUTES) ON YOUR NETWORK
#echo 1 > /proc/sys/net/ipv4/conf/all/log_martians

# DISABLE IPV4 FORWARDING
#echo 0 > /proc/sys/net/ipv4/ip_forward

netdev=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | sed -nr '1s/^([^: ]+).*/\1/p')
# These adresses are mostly used for LAN's, first network device name
netdev1=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | sed -nr '2s/^([^: ]+).*/\1/p')
# These adresses are mostly used for LAN's, second network device name

# Script is for stoping Portscan and smurf attack

### first flush all the iptables Rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# INPUT iptables Rules
# Accept loopback input
# Allow unlimited traffic on the loopback interface
iptables -A INPUT -i lo -p all -j ACCEPT
#iptables -A INPUT -i lo -j ACCEPT


# Set default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# allow 3 way handshake
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Spoofed/Invalid packets
# Reject spoofed packets
# These adresses are mostly used for LAN's, so if these would come to a WAN-only server, drop them.
### DROPspoofing packets
# Reject packets from RFC1918 class networks (i.e., spoofed)
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP
iptables -A INPUT -s 192.168.0.0/24 -j DROP

#Multicast-adresses. 
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -d 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -d 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255 -j DROP

#geoip
#iptables -A INPUT -m geoip --src-cc A1,A2 -j DROP
#iptables -A INPUT -m geoip ! --src-cc CA -j DROP
#iptables -A INPUT -m geoip ! --src-cc RU,KZ,MN,BY,CN,DE,TR,IL,IT,UA,SG -j DROP #ID,HT,IE,KP,KR,MD,MX,TH,SG
#iptables -A INPUT -m geoip ! --src-cc RU,KZ,MN,BY,CN,DE,TR,IL,IT,UA,SG  -m conntrack --ctstate NEW -j DROP
#iptables -P INPUT DROP
#iptables -A INPUT -m psd --psd-weight-threshold 15 --psd-hi-ports-weight 3 -j DROP #port scanning protection
#iptables -A OUTPUT -m geoip --dst-cc CN,IT,SG,TR,IL -j DROP

#iptables -N SSH_GEOIP
#iptables -A SSH_GEOIP -m geoip ! --src-cc RU,CN,TR,IT #-j DROP
#iptables -A INPUT -m geoip ! --src-cc RU,CN,TR,IT -j DROP

#Block Smurf attacks
#for SMURF attack protection
#iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 3 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 4 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 5 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 9 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 10 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 12 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 13 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 15 -j DROP
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m limit --limit 2/second -j ACCEPT
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP
iptables -A INPUT -p icmp -j DROP

#SYN PACKETS
iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j RETURN

# DROP INVALID SYN PACKETS
iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

iptables -A INPUT -s 0.0.0.1/32 -i lo -j LOG --log-prefix "IPKF_IPKungFu "
iptables -A INPUT -m recent --rcheck --seconds 120 --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 135 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 135: "
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 135 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 137 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 137: "
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 137 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 139 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 139: "
iptables -A INPUT -i $netdev -p tcp -m tcp --dport 139 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_ALL: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_NONE: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_XMAS: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_FIN: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_FIN: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_RST: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_SYN_RST_ACK_FIN_URG: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_NULL: "
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -p tcp -m state --state INVALID -m limit --limit 3/sec -j LOG --log-prefix "IPKF_Invalid_TCP_Flag: "
iptables -A INPUT   -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT  -m state --state INVALID -j DROP
iptables -A INPUT -i $netdev -p icmp -m icmp --icmp-type 13 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_ICMP_Timestamp: "
iptables -A INPUT -i $netdev -p icmp -m icmp --icmp-type 13 -j DROP
#iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
iptables -A INPUT -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
iptables -A INPUT -i $netdev -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -m limit --limit 3/sec -j LOG --log-prefix "IPKF_New_Not_SYN: "
iptables -A INPUT -i $netdev -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A INPUT -i $netdev -p tcp -m multiport --dports 137,6666 -j DROP
iptables -A INPUT -i $netdev -p udp -m multiport --dports 1434 -j DROP


if [ -n "${netdev1##+([[:space:]])}" ]; then
    iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 135 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 135: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 135 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 137 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 137: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 137 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 139 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 139: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --dport 139 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_ALL: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_NONE: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_XMAS: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_FIN: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_FIN: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_RST: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_SYN_RST_ACK_FIN_URG: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_NULL: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
	iptables -A INPUT -p tcp -m state --state INVALID -m limit --limit 3/sec -j LOG --log-prefix "IPKF_Invalid_TCP_Flag: "
	iptables -A INPUT   -m state --state INVALID -j DROP
	iptables -A FORWARD -m state --state INVALID -j DROP
	iptables -A OUTPUT  -m state --state INVALID -j DROP
	iptables -A INPUT -i $netdev1 -p icmp -m icmp --icmp-type 13 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_ICMP_Timestamp: "
	iptables -A INPUT -i $netdev1 -p icmp -m icmp --icmp-type 13 -j DROP
	#iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
    iptables -A INPUT -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -m limit --limit 3/sec -j LOG --log-prefix "IPKF_New_Not_SYN: "
	iptables -A INPUT -i $netdev1 -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
	iptables -A INPUT -i $netdev1 -p tcp -m multiport --dports 137,6666 -j DROP
	iptables -A INPUT -i $netdev1 -p udp -m multiport --dports 1434 -j DROP
fi


# MAKE SURE NEW INCOMING TCP CONNECTIONS ARE SYN PACKETS; OTHERWISE WE NEED TO DROP THEM 
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# LOG before dropping packets
iptables -A INPUT -j LOG --log-level warning

# DROP PACKETS WITH INCOMING FRAGMENTS. THIS ATTACK RESULT INTO LINUX SERVER PANIC SUCH DATA LOSS
iptables -A INPUT -f -j DROP

# DROP INCOMING MALFORMED XMAS PACKETS
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# DROP INCOMING MALFORMED NULL PACKETS
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Drop bogus TCP packets
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP

#Droping all invalid packets
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

# flooding of RST packets, smurf attack Rejection
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Protect against SYN floods by rate limiting the number of new
# connections from any host to 60 per second.  This does *not* do rate
# limiting overall, because then someone could easily shut us down by
# saturating the limit.
iptables -A INPUT -m state --state NEW -p tcp -m tcp --syn -m recent --name synflood --set
iptables -A INPUT -m state --state NEW -p tcp -m tcp --syn -m recent --name synflood --update --seconds 1 --hitcount 60 -j DROP

#Blocking portscan
# Attempt to block portscans
# Anyone who tried to portscan us is locked out for an entire day.
# Protecting portscans
# Attacking IP will be locked for 24 hours (3600 x 24 = 86400 Seconds)
iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP

# Remove attacking IP after 24 hours
iptables -A INPUT -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove

# These rules add scanners to the portscan list, and log the attempt.
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

# Allow the following ports through from outside
#iptables -A INPUT -p tcp -m udp --dport 53 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT

#FINGERPRINTING
iptables -A INPUT -p tcp --dport 0 -j DROP
iptables -A INPUT -p udp --dport 0 -j DROP
iptables -A INPUT -p tcp --sport 0 -j DROP
iptables -A INPUT -p udp --sport 0 -j DROP
 
# Allow ping means ICMP port is open (If you do not want ping replace ACCEPT with REJECT)
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

### 8: Limit connections per source IP ###
iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
### 9: Limit RST packets ###
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
### 10: Limit new TCP connections per second per source IP ###
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

### 11: Use SYNPROXY on all ports (disables connection limiting rule) ###
#iptables -t raw -D PREROUTING -p tcp -m tcp --syn -j CT --notrack
#iptables -D INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
#iptables -D INPUT -m conntrack --ctstate INVALID -j DROP

### SSH brute-force protection ###
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
### Protection against port scanning ### 
iptables -N port-scanning 
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN 
iptables -A port-scanning -j DROP

#The attacks being blocked are, respectively:
#SYN-FIN attack
#SYN-RST attack
#X-Mas attack
#nmap FIN scan
#NULLflags attack
#ALLflags attack

#Block ICMP attacks
#Add the following rules, preferably in -t raw -A PREROUTING
iptables -t raw -A PREROUTING -p icmp -m u32 ! --u32 "4&0x3FFF=0"   -j DROP
iptables -t raw -A PREROUTING -p icmp -m length --length 1492:65535 -j DROP
#The first rule blocks all ICMP packets whose "fragmentation flag" is not 0. (ICMP should never be fragmented; they should be carrying small payloads)
#The second rule blocks oversized unfragmented ICMP packets.

#Makes iptables wait 15 seconds between new connections from the same IP:
#iptables -A INPUT -p tcp -i $netdev -m state --state NEW --dport 22 -m recent --update --seconds 15 -j DROP
#iptables -A INPUT -p tcp -i $netdev -m state --state NEW --dport 22 -m recent --set -j ACCEPT

#Block ICMP (aka ping)
# Don't allow pings through
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP

# Lastly reject All INPUT traffic
#iptables -A INPUT -j REJECT
iptables -A INPUT -j DROP


############################################## FORWARD ####################################################################
iptables -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A FORWARD -s 127.0.0.1/32 -o $netdev -p udp -m state --state INVALID -j REJECT --reject-with icmp-port-unreachable
iptables -t filter -A FORWARD -s 127.0.0.1/32 -o $netdev -p tcp -m state --state INVALID -j REJECT --reject-with icmp-port-unreachable
iptables -t filter -A FORWARD -i $netdev -m recent --rcheck --seconds 120 --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 135 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 135: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 135 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 137 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 137: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 137 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 139 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 139: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --dport 139 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_ALL: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_NONE: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_FIN_URG_PSH: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_XMAS: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_FIN: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_RST: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_SYN_RST_ACK_FIN_URG: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_NULL: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m state --state INVALID -m limit --limit 3/sec -j LOG --log-prefix "IPKF_Invalid_TCP_flag: "
iptables -t filter -A FORWARD -i $netdev -m state --state INVALID -j DROP
iptables -t filter -A FORWARD -i $netdev -p icmp -m icmp --icmp-type 13 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_ICMP_Timestamp: "
iptables -t filter -A FORWARD -i $netdev -p icmp -m icmp --icmp-type 13 -j DROP
#iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -m limit --limit 3/sec -j LOG --log-prefix "IPKF_New_Not_SYN: "
iptables -t filter -A FORWARD -i $netdev -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -t filter -A FORWARD -i $netdev -p tcp -m multiport --dports 137,6666 -j DROP
iptables -t filter -A FORWARD -i $netdev -p udp -m multiport --dports 1434 -j DROP

if [ -n "${netdev1##+([[:space:]])}" ]; then
	iptables -t filter -A FORWARD -s 127.0.0.1/32 -o $netdev1 -p udp -m state --state INVALID -j REJECT --reject-with icmp-port-unreachable
	iptables -t filter -A FORWARD -s 127.0.0.1/32 -o $netdev1 -p tcp -m state --state INVALID -j REJECT --reject-with icmp-port-unreachable
	iptables -t filter -A FORWARD -i $netdev1 -m recent --rcheck --seconds 120 --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 135 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 135: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 135 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 137 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 137: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 137 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 139 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_BADGUY_on_port 139: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --dport 139 -m recent --set --name badguy --mask 255.255.255.255 --rsource -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_ALL: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_NONE: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_FIN_URG_PSH: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_XMAS: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_FIN: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -m limit --limit 3/sec -j LOG --log-prefix "IPKF_flags_SYN_RST: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -m limit --limit 3/sec -j LOG --log-prefix "IPKF_SYN_RST_ACK_FIN_URG: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -m limit --limit 3/sec -j LOG --log-prefix "IPKF_PORTSCAN_nmap_NULL: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m state --state INVALID -m limit --limit 3/sec -j LOG --log-prefix "IPKF_Invalid_TCP_flag: "
	iptables -t filter -A FORWARD -i $netdev1 -m state --state INVALID -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p icmp -m icmp --icmp-type 13 -m limit --limit 3/sec -j LOG --log-prefix "IPKF_ICMP_Timestamp: "
	iptables -t filter -A FORWARD -i $netdev1 -p icmp -m icmp --icmp-type 13 -j DROP
	#iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
    iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -m limit --limit 3/sec -j LOG --log-prefix "IPKF_New_Not_SYN: "
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p tcp -m multiport --dports 137,6666 -j DROP
	iptables -t filter -A FORWARD -i $netdev1 -p udp -m multiport --dports 1434 -j DROP
fi

#iptables -A syn-flood -m limit --limit 10/sec --limit-burst 24 -j RETURN
#iptables -A syn-flood -m limit --limit 3/sec -j LOG --log-prefix "IPKF_SYN_flood: "
#iptables -A syn-flood -j DROP

####################################### PREROUTING ####################################################################
#Block Well-Known TCP Attacks
#The attacks being blocked are, respectively:
#SYN-FIN attack
#SYN-RST attack
#X-Mas attack
#nmap FIN scan
#NULLflags attack
#ALLflags attack
#Add the following rules, preferably in 
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP

#Block ICMP attacks
#Add the following rules, preferably in -t raw -A PREROUTING
iptables -t raw -A PREROUTING -p icmp -m u32 ! --u32 "4&0x3FFF=0"   -j DROP
iptables -t raw -A PREROUTING -p icmp -m length --length 1492:65535 -j DROP
#The first rule blocks all ICMP packets whose "fragmentation flag" is not 0. (ICMP should never be fragmented; they should be carrying small payloads)
#The second rule blocks oversized unfragmented ICMP packets.

### 1: Drop invalid packets ###
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
### 2: Drop TCP packets that are new and are not SYN ###
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
### 3: Drop SYN packets with suspicious MSS value ###
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
### 4: Block packets with bogus TCP flags ###
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
### 5: Block spoofed packets ###
### Block Packets From Private Subnets (Spoofing)
iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP 
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP 
iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP 
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP 
#iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP 
iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP 
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP 
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP 
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

# 6: Drop ICMP (you often don't need this protocol)
iptables -t mangle -A PREROUTING -p icmp -j DROP
# 7: Drop fragments in all chains
iptables -t mangle -A PREROUTING -f -j DROP


################# Below are for OUTPUT iptables rules #############################################

## Allow loopback OUTPUT 
iptables -A OUTPUT -o lo -j ACCEPT
#iptables -A OUTPUT -o lo -p all -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow the following ports through from outside 
# SMTP = 25
# DNS =53
# HTTP = 80
# HTTPS = 443
# SSH = 22
### You can also add or remove port no. as per your requirement

# DROP INVALID SYN PACKETS
iptables -A OUTPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

# MAKE SURE NEW OUTGOING TCP CONNECTIONS ARE SYN PACKETS; OTHERWISE WE NEED TO DROP THEM 
iptables -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP

# DROP PACKETS WITH OUTGOING FRAGMENTS. THIS ATTACK RESULT INTO LINUX SERVER PANIC SUCH DATA LOSS
iptables -A OUTPUT -f -j DROP

# DROP OUTGOING MALFORMED XMAS PACKETS
iptables -A OUTPUT -p tcp --tcp-flags ALL ALL -j DROP

# DROP OUTGOING MALFORMED NULL PACKETS
iptables -A OUTPUT -p tcp --tcp-flags ALL NONE -j DROP

iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT # dns
#iptables -A OUTPUT -p tcp -m tcp --dport 21 -j ACCEPT #ftp
#iptables -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT #ftp
#iptables -A OUTPUT -p tcp -m tcp --dport 25 -j ACCEPT
#iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT  # http
#iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT # https
iptables -A OUTPUT -p udp -m iprange --dst-range 192.168.0.1-192.168.0.1 --dport 67 -j ACCEPT # dhcp
iptables -A OUTPUT -p udp -m iprange --dst-range 192.168.0.1-192.168.0.1 --dport 68 -j ACCEPT # dhcp
#iptables -A OUTPUT -p tcp -m tcp --dport 9001 -j ACCEPT # tor browser

#iptables -A OUTPUT -p tcp -m tcp --dport 11371 -j ACCEPT  # dnscrypt for install
#iptables -A OUTPUT -p tcp -m tcp --dport 17371 -j ACCEPT  # dnscrypt for install

iptables -A OUTPUT -p tcp -m tcp --dport 465 -j ACCEPT # smtp.gmail.com SSL
iptables -A OUTPUT -p tcp -m tcp --dport 587 -j ACCEPT # smtp.gmail.com StartTLS
iptables -A OUTPUT -p tcp -m tcp --dport 995 -j ACCEPT # pop.gmail.com SSL
iptables -A OUTPUT -p tcp -m tcp --dport 993 -j ACCEPT # imap.gmail.com SSL

# accept packets for internet group
#iptables -A OUTPUT -p udp -m owner --dport 53 --gid-owner ginternetg -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --dport 80 --uid-owner firefox -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --dport 443 --uid-owner firefox -j ACCEPT
#iptables -A OUTPUT -p tcp -m owner --dport 80 --uid-owner jupiter -j ACCEPT
#iptables -A OUTPUT -p tcp -m owner --dport 443 --uid-owner jupiter -j ACCEPT

#iptables -A OUTPUT -p tcp -m owner --dport 443 --uid-owner privoxy -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --dport 443 --uid-owner debian-tor -j ACCEPT
#iptables -A OUTPUT -p tcp -m owner --dport 80 --uid-owner _apt -j ACCEPT
#iptables -A OUTPUT -p tcp -m owner --dport 443 --uid-owner _apt -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --dport 80 --gid-owner ginet -j ACCEPT
iptables -A OUTPUT -p tcp -m owner --dport 443 --gid-owner ginet -j ACCEPT
#iptables -A OUTPUT -p tcp -m owner  -d 82.144.192.7 --dport 80 --gid-owner ginet -j ACCEPT
# Ubuntu update servers
#iptables -A OUTPUT -p tcp -m iprange --dst-range 91.189.88.149-91.189.88.152 --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp -m iprange --dst-range 91.189.88.161-91.189.88.162 --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp -m iprange --dst-range 91.189.92.150-91.189.92.151 --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp -m iprange --dst-range 192.30.253.112-192.30.253.113 --dport 443 -j ACCEPT
#iptables -A OUTPUT -p tcp -m iprange --dst-range 151.101.120.133-151.101.120.133 --dport 443 -j ACCEPT
#clamAV databases
iptables -A OUTPUT -p tcp -m iprange --dst-range 195.228.75.149-195.228.75.149 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 129.67.1.218-129.67.1.218 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 217.19.16.188-217.19.16.188 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 212.7.0.71-212.7.0.71 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 193.1.193.64-193.1.193.64 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 152.66.249.135-152.66.249.135 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 82.195.224.39-82.195.224.39 --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m iprange --dst-range 194.228.41.73-194.228.41.73 --dport 80 -j ACCEPT
# DNSCrypt
#iptables -A OUTPUT -p udp -m owner --dport 443 --uid-owner dnscrypt -j ACCEPT
#iptables -A OUTPUT -m owner --uid-owner dnscrypt -j DROP
#iptables -A OUTPUT -p udp -m owner --dport 443 --uid-owner nobody -j ACCEPT
#iptables -A OUTPUT -m owner --uid-owner nobody -j DROP

# NTP (server time)
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

iptables -t mangle -A OUTPUT -p icmp -j TOS --set-tos 0x10/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 20 -j TOS --set-tos 0x08/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 21 -j TOS --set-tos 0x10/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 22 -j TOS --set-tos 0x10/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 21 -j TOS --set-tos 0x10/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 25 -j TOS --set-tos 0x10/0x3f
iptables -t mangle -A OUTPUT -p udp -m udp --dport 53 -j TOS --set-tos 0x08/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 63 -j TOS --set-tos 0x10/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 80 -j TOS --set-tos 0x08/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 110 -j TOS --set-tos 0x08/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 113 -j TOS --set-tos 0x10/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 123 -j TOS --set-tos 0x10/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 143 -j TOS --set-tos 0x08/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 443 -j TOS --set-tos 0x08/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 993 -j TOS --set-tos 0x08/0x3f
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 995 -j TOS --set-tos 0x08/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 1080 -j TOS --set-tos 0x10/0x3f
#iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 6000:6063 -j TOS --set-tos 0x08/0x3f

iptables -t mangle -A PREROUTING -p tcp --sport ftp -j TOS --set-tos Minimize-Delay
iptables -t mangle -A PREROUTING -p tcp --sport ftp-data -j TOS --set-tos Maximize-Throughput

# Allow pings
#iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP # ping
#iptables -A OUTPUT -p icmp --icmp-type 3 -j ACCEPT #
#iptables -A OUTPUT -p icmp --icmp-type 4 -j ACCEPT #
#iptables -A OUTPUT -p icmp --icmp-type 11 -j ACCEPT #
#iptables -A OUTPUT -p icmp --icmp-type 12 -j ACCEPT #

# Lastly Reject all Output traffic
iptables -A OUTPUT -j DROP
#iptables -A OUTPUT -j ACCEPT

## Reject Forwarding  traffic
iptables -A FORWARD -j DROP

mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

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


#/sbin/ipset -N kiddies iphash
#iptables -t raw -N kiddies
#iptables -t raw -A kiddies -j MARK --set-mark 13
#iptables -t raw -A kiddies -j NOTRACK
#iptables -t raw -I PREROUTING -m set --match-set kiddies src -j kiddies
#iptables -N kiddies
#iptables -A kiddies -p tcp -j CHAOS --tarpit
#iptables -A kiddies -j DROP
#iptables -N blklst_n_lock
#iptables -A blklst_n_lock -j SET --add-set kiddies src
#iptables -A blklst_n_lock -j kiddies
#iptables -I INPUT -m psd -j blklst_n_lock
#iptables -I INPUT -m mark --mark 13 -j kiddies
