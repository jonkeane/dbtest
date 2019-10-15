brew services start postgresql

createuser -s root
psql -U root -c "CREATE ROLE username WITH LOGIN PASSWORD '6c9FT%Kj'"
export PGPASSWORD=6c9FT%Kj
psql -U travis -c "CREATE DATABASE nycflights;"
