dropdb $1
createdb $1

psql $1 -f $1.sql