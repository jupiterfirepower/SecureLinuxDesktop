#sudo ufw enable
#sudo ufw status verbose
#sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade
lsb_release -a
sudo sed -i 's/false/true/g' /etc/apt/apt.conf.d/00recommends
sudo apt-get -y remove --purge mono-runtime-common gnome-orca 
sudo apt-get -y install totem-plugins-extra  ubuntu-restricted-extras 
#Disable hibernation (suspend-to-disk)
sudo mv -v /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla /
# Undo sudo mv -v /com.ubuntu.enable-hibernate.pkla /etc/polkit-1/localauthority/50-local.d
# Install full multimedia support
sudo apt-get -y install libdvd-pkg
chmod -v 700 $HOME
#chmod -v 755 $HOME
#Browsers
# Google Chrome
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo gdebi google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Chromium Browser
sudo apt-get -y install chromium-browser
# Opera Browser
sudo sh -c 'echo "deb http://deb.opera.com/opera/ stable non-free" >> /etc/apt/sources.list.d/opera.list'
sudo wget http://deb.opera.com/archive.key -q -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install opera-stable
#sudo apt-get remove opera
#sudo apt-get purge opera
#sudo apt-get autoremove
#sudo apt-get autoclean
# Deb repository
#deb http://deb.opera.com/opera/ stable non-free
#deb http://deb.opera.com/opera-beta/ stable non-free
#get -qO - http://deb.opera.com/archive.key | sudo apt-key add -
#sudo apt-get install debian-archive-keyring
#sudo apt-get update
#sudo apt-get install opera
#Slimjet Browser
sudo wget http://www.slimjet.com/release/archive/15.1.1.0/slimjet_amd64.deb
#sudo gdebi slimjet_amd64.deb
sudo dpkg -i slimjet_amd64.deb
# Pale Moon Browser

# Ubuntu
if [ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]; then
  	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_17.04/ /' > /etc/apt/sources.list.d/palemoon.list"
	sudo wget -nv http://download.opensuse.org/repositories/home:stevenpusser/xUbuntu_17.04/Release.key -O Release.key
	sudo apt-key add - < Release.key
	sudo apt-get update
	sudo apt-get install palemoon
else
  	sudo wget http://linux.palemoon.org/datastore/release/pminstaller-0.2.3.tar.bz2
	sudo tar xvjf pminstaller-0.2.3.tar.bz2
	cd pminstaller-0.2.3
	sudo ./pminstaller.sh
fi
#https://software.opensuse.org/download.html?project=home:stevenpusser&package=palemoon
#sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_17.04/ /' > /etc/apt/sources.list.d/palemoon.list"
#sudo apt-get update
#sudo apt-get install palemoon
# Qupzila
#sudo add-apt-repository ppa:nowrep/qupzilla -y
#sudo apt-get update && sudo apt-get -y install qupzilla
# Seamonkey Browser
#echo -e "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" | sudo tee -a /etc/apt/sources.list > /dev/null
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
#sudo apt-get update
#sudo apt-get -y install seamonkey-mozilla-build
# Otter Browser
#sudo add-apt-repository ppa:otter-browser/release
#sudo apt-get update
#sudo apt-get install otter-browser -y
# Tor Browser
sudo add-apt-repository ppa:webupd8team/tor-browser -y
sudo apt-get update
sudo apt-get -y install tor-browser
# Midory Browser
#sudo apt-add-repository ppa:midori/ppa -y && sudo apt-get update -qq && sudo apt-get -y install midori 
#Install terminal
sudo apt-get -y install guake
sudo apt-get -y install terminator
sudo apt-get -y install roxterm
# Email Client
sudo apt-get -y install thunderbird
sudo apt-get -y install evolution
#sudo apt-get -y install sylpheed
# Download manager
sudo apt-get -y install aria2
sudo apt-get -y install curl
sudo apt-get -y install axel
sudo add-apt-repository ppa:noobslab/apps -y
sudo apt-get update
sudo apt-get -y install xdman
sudo apt-get -y install uget
# Text Editor
sudo apt-get -y install gedit leafpad medit
sudo apt-get -y install mousepad
sudo apt-get -y install scribes
sudo apt-get -y install xpad
# Daemon tools
sudo apt-get -y install acetoneiso
# Pdf reader
sudo apt-get -y install evince
# calibre ebook reader manager
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#
sudo apt-get -y install doublecmd-gtk catfish
# Audio 
sudo apt-get -y install pavucontrol
sudo apt-get -y install pulseaudio-equalizer
# Skype
sudo apt-get -y install skype
# Numlock
sudo apt-get -y install numlockx
# Unetbootin
sudo apt-get -y install unetbootin
sudo apt-get -y install usbmount
# Source Control System
sudo apt-get -y install git
# Archivators
sudo apt-get -y install unace rar unrar p7zip-rar p7zip zip unzip sharutils uudeview mpack arj cabextract file-roller
#flashplugin-installer
sudo apt-get -y install  gsfonts-x11 gxine mencoder mpeg2dec vorbis-tools id3v2 mpg321 mpg123 ffmpeg icedax tagtool easytag id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs 
sudo apt-get -y install flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac mpeg3-utils mpegdemux liba52-0.7.4-dev libquicktime2 
sudo apt-get -y install totem-plugins-extra  ubuntu-restricted-extras
sudo apt-get -y install mint-meta-codecs
sudo apt-get -y install pepperflashplugin-nonfree
sudo apt-get -y install vlc browser-plugin-vlc
# Clementine Audio Player
sudo apt-get -y install clementine
#Install Inkscape Image Editor
sudo apt-get -y install inkscape
sudo apt-get -y install qbittorrent
# 
sudo apt-get -y install bleachbit
# Analog Point
sudo apt-get -y install kolourpaint4
#sudo add-apt-repository ppa:achadwick/mypaint-testing -y
#sudo apt-get update
#sudo apt-get -y install mypaint 
#sudo add-apt-repository ppa:pinta-maintainers/pinta-stable -y
#sudo apt-get update
#sudo apt-get -y install pinta 
# Dropbox for Debian #
# sudo wget https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb
# sudo dpkg -i dropbox_2015.10.28_amd64.deb
# Dropbox for Ubuntu/LinuxMint #
sudo wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb
sudo dpkg -i dropbox_2015.10.28_amd64.deb
#Partition Magic
#GParted
sudo apt-get -y install acetoneiso
#sudo dpkg --configure -a
#sudo apt-get install -f
# Flash Player
#sudo add-apt-repository ppa:nilarimogard/webupd8 -y
#sudo apt-get update
#sudo apt-get -y install freshplayerplugin

sudo apt-get -y autoremove
sudo apt-get autoclean









