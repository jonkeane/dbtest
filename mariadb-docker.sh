# stop the travis mariadb
sudo service mariadb stop || true

docker pull mariadb

# on macos, you can only run port forwards
docker run --name dbtest-mariadb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=r2N5y7V* -d mariadb:latest

# retry until mariadb is up (or 15 times)
n=0
until [ $n -ge 15 ]
do
    docker exec -it dbtest-mariadb mysql -pr2N5y7V* -e "CREATE DATABASE nycflights;" && break  # substitute your command here
   n=$[ $n+1 ]
   sleep 15
done


docker exec -it dbtest-mariadb mysql -pr2N5y7V* -e "CREATE USER IF NOT EXISTS travis@'%'; GRANT ALL ON *.* TO travis@'%'; FLUSH PRIVILEGES;"



# docker stop dbtest-mariadb
# docker rm dbtest-mariadb
#
# docker exec -it dbtest-mariadb mysql -pr2N5y7V* -e "DROP DATABASE nycflights;"
