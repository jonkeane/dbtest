rm -rf /usr/local/var/postgres
initdb /usr/local/var/postgres
pg_ctl -D /usr/local/var/postgres start
psql -U travis -c "CREATE DATABASE nycflights;"
