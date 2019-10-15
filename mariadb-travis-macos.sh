rm -f /etc/my.cnf
brew install mariadb
brew services start mariadb
mkdir /usr/local/etc/my.cnf.d
sleep 5
mysql -uroot -e "CREATE DATABASE nycflights;"
mysql -uroot -e "CREATE USER IF NOT EXISTS travis@'%'; GRANT ALL ON *.* TO travis@'%'; FLUSH PRIVILEGES;"
