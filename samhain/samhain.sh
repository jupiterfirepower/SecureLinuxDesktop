apt-get -y install dialog
wget http://www.la-samhna.de/samhain/samhain-current.tar.gz
tar -xvzf samhain-current.tar.gz
cd samhain-current/
#gpg --keyserver pgp.mit.edu --recv-key 0F571F6C
#gpg --fingerprint 0F571F6C
#gpg --verify samhain-4.2.1.tar.gz.asc samhain-4.2.1.tar.gz
tar -xvzf samhain-4.2.1.tar.gz
cd samhain-*

./configure --enable-static --enable-login-watch --enable-mounts-check --enable-logfile-monitor --enable-process-check --enable-port-check --enable-userfiles --enable-suidcheck
make
make install
make install-boot

cp samhainerc /etc/samhainrc
chown root:root /etc/samhainrc

samhain -t init #|update
