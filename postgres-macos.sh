rm -rf /usr/local/var/postgres
initdb /usr/local/var/postgres
pg_ctl -D /usr/local/var/postgres start

createuser -s postgres
psql -U postgres -c "CREATE ROLE travis WITH LOGIN PASSWORD '6c9FT%Kj'"
export PGPASSWORD=6c9FT%Kj
psql -U travis -c "CREATE DATABASE nycflights;"
