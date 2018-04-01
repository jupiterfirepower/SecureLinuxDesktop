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
f_remservices           # 41_remservices
f_remusersgroups        # 42_remusersgroups
f_portsentry    # 46_portsentry
f_tor_privoxy	# 49_tor_privoxy
f_diffsettings  # 56_diffsettings
f_disableguest  # 57_disableguest
f_macchanger  	# 58_macchanger real uncomment
f_mylogindefs	# 60_logindefs
f_pampassword	# 63_pampassword
f_firefoxuserpref # 67_firefoxuserpref
f_aptget		# 10_aptget
f_hosts		    # 11_hosts
f_issue		    # 34_issue
f_packages		# 17_packages
f_cronrkhunter	# 65_cronrkhunter
f_apport		# 35_apport
f_ctrlaltdel	# 21_ctraltdel
f_aide			# 24_aide
f_lockroot		# 36_lockroot
f_aptget_clean	# 10_aptget
f_hardfirefox	# 70_HardeninFirefox
f_aa_enforce	# 29_apparmor
f_aide_post	# 24_aide
f_aide_timer	# 24_aide
f_systemddelta	# 98_systemddelta
f_checkreboot	# 99_reboot
#f_snort		# 74_snort
f_myfstab	# 61_fstab

echo
