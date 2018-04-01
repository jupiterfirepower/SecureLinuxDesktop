#!/bin/bash

# Disable the default single-click policy
sudo gsettings set org.pantheon.files.preferences single-click false

sudo apt -y install software-properties-common git dconf-editor software-properties-gtk

# Install gdebi so you can install deb packages trough GUI
sudo apt -y install gdebi

sudo apt-get -y install synaptic

# Install archive formats
sudo apt -y install unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip

sudo add-apt-repository ppa:philip.scott/elementary-tweaks -y
sudo apt-get update
sudo apt-get -y install elementary-tweaks

#sudo add-apt-repository ppa:mpstark/elementary-tweaks-daily
#sudo apt-get update
#sudo apt-get install elementary-tweaks

#apt-get -y install apparmor-profiles apparmor-utils #apparmor

sudo apt-get -y install libnotify-bin
sudo notify-send "Hello libnotify!"

#apt-get -y install macchanger macchanger-gtk

# install the complete suite 
# For office productivity, install well known LibreOffice
sudo apt-get -y install libreoffice 

#install only each component 
#sudo apt-get install libreoffice-writer
#sudo apt-get install libreoffice-calc
#sudo apt-get install libreoffice-impress
#sudo apt-get install libreoffice-math
#sudo apt-get install libreoffice-draw
#sudo apt-get install libreoffice-base

#Transmission
#sudo apt-get -y install transmission
#Deluge 
#sudo apt-get -y install deluge
#qBittorrent 
#sudo apt-get -y install qbittorrent
#KTorrent 
#sudo apt-get -y install ktorrent

# For watching videos we will use VLC
sudo apt -y install vlc

#Install other web browsers
sudo apt-get -y install chromium-browser #firefox

#64 bit
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo gdebi google-chrome-stable_current_amd64.deb

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get install -f

# Patent-encumbered technology
sudo apt -y install ubuntu-restricted-extras

# Codecs for video editing
sudo apt -y install libavcodec-extra ffmpeg
sudo apt-get -y install libdvd-pkg

# If we need to do some photo editing, we will need GIMP
sudo apt -y install gimp

# Install blender, which can be used for 3d modeling, animation, and video editing
#sudo apt install blender

# In case you have NVIDIA graphics card
sudo apt -y install nvidia-current

# USE NIGHT SHIFT TO SAVE YOUR EYES
sudo apt -y install redshift

sudo chmod 744 /usr/lib/gvfs/gvfsd-smb-browse

#Install Gimp, InkScape and Shutter for your imaging needs:
#sudo apt install gimp inkscape shutter

#Plugin Flash Player and Pepper Flash
sudo apt-get -y install flashplugin-installer pepperflashplugin-nonfree

# Install Backup Software
sudo apt-add-repository ppa:teejee2008/ppa -y
sudo apt-get update
sudo apt-get -y install timeshift

# Power and Heat Management
#Install TLP
sudo add-apt-repository ppa:linrunner/tlp -y
sudo apt-get update
sudo apt-get -y install tlp tlp-rdw
sudo tlp start
#Install Laptop Mode Tools
#sudo add-apt-repository ppa:ubuntuhandbook1/apps
#sudo apt-get update
#sudo apt-get install laptop-mode-tools
#After installing, get the GUI for further customization by running the following command.

#sudo tlp start
#gksu lmt-config-gui

sudo add-apt-repository ppa:noobslab/icons -y
sudo apt-get update
sudo apt-get -y install elementary-add-icons

sudo add-apt-repository ppa:moka/daily -y
sudo apt-get update
sudo apt-get -y install moka-icon-theme

sudo add-apt-repository ppa:numix/ppa -y
sudo apt-get update
sudo apt-get -y install numix-gtk-theme numix-icon-theme-circle
sudo apt-get -y install numix-wallpaper-*


# Best Ubuntu Themes
sudo apt-add-repository ppa:tista/adapta -y
sudo apt update
sudo apt -y install adapta-gtk-theme

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/vertex-theme.list"
sudo apt update
sudo apt -y install vertex-theme

#zypper addrepo http://download.opensuse.org/repositories/home:Horst3180/openSUSE_Tumbleweed/home:Horst3180.repo
#zypper refresh
#zypper install vertex-theme

#zypper addrepo http://download.opensuse.org/repositories/home:Horst3180/openSUSE_Leap_42.1/home:Horst3180.repo
#zypper refresh
#zypper install vertex-theme

echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' >> /etc/apt/sources.list.d/vertex-theme.list
apt update
apt -y install vertex-theme

sudo add-apt-repository ppa:varlesh-l/papirus-pack -y
sudo apt-get update
sudo apt-get -y install papirus-gtk-icon-theme

sudo add-apt-repository ppa:noobslab/icons -y
sudo apt-get update
sudo apt-get -y install trevilla-icons
#Trevilla Themes
sudo add-apt-repository ppa:noobslab/themes -y
sudo apt-get update
sudo apt-get -y install trevilla-themes

sudo add-apt-repository ppa:snwh/pulp -y
sudo apt-get update
sudo apt-get -y install paper-icon-theme paper-gtk-theme

sudo add-apt-repository ppa:noobslab/themes -y
sudo apt-get update
sudo apt-get -y install arc-theme

sudo add-apt-repository ppa:noobslab/icons -y
sudo apt-get update
sudo apt-get -y install arc-icons

