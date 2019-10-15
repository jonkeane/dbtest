rm -f /etc/my.cnf
brew install mariadb
brew services start mariadb
sleep 5
mysql -e "CREATE DATABASE nycflights;"
mysql -e "CREATE USER IF NOT EXISTS travis@'%'; GRANT ALL ON *.* TO travis@'%'; FLUSH PRIVILEGES;"
