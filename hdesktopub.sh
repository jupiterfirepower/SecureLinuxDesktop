#!/bin/bash

#if ! ps -p $$ | grep -i bash; then
#       echo "Sorry, this script requires bash."
#       exit 1
#fi

if ! [ -x "$(which systemctl)" ]
  then
    echo "systemctl required. Exiting."
    exit 1
fi

clear

source ./hdesktop.cfg

for s in ./scripts/[0-9_]*; do
  [[ -e $s ]] || break
  source "$s"
done

f_pre			# 01_pre
f_firewall		# 02_ufw
#f_preparefirewall       # 71_preparefirewall
#f_iptablesfirewall      # 72_iptablesfirewall
f_remservices           # 41_remservices
f_remusersgroups        # 42_remusersgroups
#f_clamav  		# 43_clamav
#f_chkrootkit 	# 44_chkrootkit
f_portsentry    # 46_portsentry
#f_suricata      # 47_suricata
#f_maldetect     # 48_maldetect
#f_tor_privoxy	# 49_tor_privoxy 
#f_add_secutils  # 50_addsecutils acct arpwatch 
f_logprotect	# 51_logprotect
#f_bruteforce	# 52_bruteforce 
f_autosecupdates # 53_autosecupdates
#f_securetty 	# 54_securetty
#f_filesperm	# 55_filesperm
f_diffsettings  # 56_diffsettings
f_disableguest  # 57_disableguest
f_macchanger  	# 58_macchanger real uncomment
#f_cryptswap  	# 59_cryptswap
f_mylogindefs	# 60_logindefs
f_securedelete	# 62_securedelete
f_pampassword	# 63_pampassword
f_firefoxuserpref # 67_firefoxuserpref
#f_disablenet	# 03_disablenet
#f_disablemnt	# 04_disablemnt
#f_disablemod   # 23_disablemod
#f_systemdconf	# 05_systemdconf
#f_resolvedconf # 32_resolvedconf
#f_logindconf	# 31_logindconf
#f_journalctl    # 06_journalctl - 
#f_timesyncd		# 07_timesyncd
#f_coredump		# 37_coredump
#f_fstab		# 08_fstab -
#f_prelink		# 09_prelink not for desktop Prelink и Preload для ускорения запуска программ в Linux
f_aptget		# 10_aptget
f_hosts		    # 11_hosts
f_issue		    # 34_issue
#f_logindefs	# 12_logindefs -
#f_sysctl		# 13_sysctl - NOT FOR UBUNTU
#f_limitsconf	# 14_limits
#f_adduser		# 15_adduser -
#f_rootaccess	# 16_rootaccess securetty -
#f_packages		# 17_packages
#f_cronrkhunter	# 65_cronrkhunter
#f_apport		# 35_apport
#f_rkhunter		# 33_rkhunter
#f_sshdconfig	# 18_sshdconfig
#f_password		# 19_password
#f_cron			# 20_cron  - not for desktop
f_ctrlaltdel	# 21_ctraltdel
#f_auditd		# 22_auditd
#f_aide			# 24_aide
#f_rhosts		# 25_rhosts
#f_users		# 26_users
f_lockroot		# 36_lockroot
f_aptget_clean	# 10_aptget
f_hardfirefox	# 70_HardeninFirefox
#f_suid			# 27_suid
#f_umask		# 28_umask
#f_path			# 30_path
#f_aa_enforce	# 29_apparmor
#f_aide_post	# 24_aide
#f_aide_timer	# 24_aide
#f_systemddelta	# 98_systemddelta
#f_checkreboot	# 99_reboot
#f_samhain	# 73_samhain
#f_snort		# 74_snort
f_myfstab	# 61_fstab
echo
