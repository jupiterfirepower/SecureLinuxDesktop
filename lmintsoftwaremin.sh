#sudo ufw enable
#sudo ufw status verbose
#sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade
lsb_release -a
sudo sed -i 's/false/true/g' /etc/apt/apt.conf.d/00recommends
sudo apt-get -y remove --purge mono-runtime-common gnome-orca 
#Disable hibernation (suspend-to-disk)
sudo mv -v /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla /
# Undo sudo mv -v /com.ubuntu.enable-hibernate.pkla /etc/polkit-1/localauthority/50-local.d
# Install full multimedia support
chmod -v 700 $HOME
# Tor Browser
sudo -g ginet add-apt-repository ppa:webupd8team/tor-browser -y
sudo apt-get update
sudo apt-get -y install tor-browser
sudo apt-get -y install guake
# Email Client
sudo apt-get -y install evolution
sudo apt-get -y install sylpheed
# Download manager
sudo apt-get -y install aria2
sudo apt-get -y install curl
sudo apt-get -y install axel
sudo apt-get -y install uget
# Text Editor
sudo apt-get -y install medit #gedit leafpad 
# Daemon tools
#sudo apt-get -y install acetoneiso
# Pdf reader
sudo apt-get -y install evince
# calibre ebook reader manager
#sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
#
#sudo apt-get -y install doublecmd-gtk catfish
# Audio 
sudo apt-get -y install pavucontrol
sudo apt-get -y install pulseaudio-equalizer
# Skype
#sudo apt-get -y install skype
# Numlock
#sudo apt-get -y install numlockx
# Unetbootin
sudo apt-get -y install unetbootin
#sudo apt-get -y install usbmount
# Source Control System
#sudo apt-get -y install git
# Archivators
sudo apt-get -y install unace rar unrar p7zip-rar p7zip zip unzip sharutils uudeview mpack arj cabextract file-roller
#flashplugin-installer
sudo apt-get -y install gsfonts-x11 gxine mencoder mpeg2dec vorbis-tools id3v2 mpg321 mpg123 ffmpeg icedax tagtool easytag id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs 
sudo apt-get -y install flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac mpeg3-utils mpegdemux liba52-0.7.4-dev libquicktime2 
#sudo apt-get -y install totem-plugins-extra  ubuntu-restricted-extras
sudo apt-get -y install mint-meta-codecs
sudo apt-get -y install pepperflashplugin-nonfree
sudo apt-get -y install vlc browser-plugin-vlc
# Clementine Audio Player
#sudo apt-get -y install clementine
#Install Inkscape Image Editor
#sudo apt-get -y install inkscape
sudo apt-get -y install qbittorrent
#
#sudo apt-get -y install bleachbit
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
#sudo wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb
#sudo dpkg -i dropbox_2015.10.28_amd64.deb
#Partition Magic
#GParted
sudo apt-get -y install gparted
#sudo dpkg --configure -a
#sudo apt-get install -f
# Flash Player
#sudo add-apt-repository ppa:nilarimogard/webupd8 -y
#sudo apt-get update
#sudo apt-get -y install freshplayerplugin

sudo apt-get -y autoremove
sudo apt-get autoclean









