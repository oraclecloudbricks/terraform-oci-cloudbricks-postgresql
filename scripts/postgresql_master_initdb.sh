#!/bin/bash

export pg_version='${pg_version}'
export DATA_DIR="/u01/data"

sudo mkdir -p /u01/data
sudo chown -R postgres:postgres /u01

sudo tee -a /etc/systemd/system/postgresql.service > /dev/null <<'EOF'
.include /usr/lib/systemd/system/postgresql-${pg_version}.service
[Service]

# Location of database directory
Environment=PGDATA=/u01/data
Environment=PGLOG=/u01/data/pgstartup.log
EOF

# Optionally initialize the database and enable automatic start:
if [[ $pg_version == "9.6" ]]; then 
	#sudo /usr/pgsql-${pg_version}/bin/postgresql${pg_version_no_dot}-setup initdb -D /u01/data
	sudo su - postgres -c  "/usr/pgsql-${pg_version}/bin/initdb -D $DATA_DIR"
	sudo semanage fcontext -a -t postgresql_db_t "/u01/data(/.*)?"
	sudo restorecon -R -v /u01/data


else
	#sudo /usr/pgsql-${pg_version}/bin/postgresql-${pg_version_no_dot}-setup initdb -D /u01/data
	sudo su - postgres -c  "/usr/pgsql-${pg_version}/bin/initdb -D $DATA_DIR"
	sudo semanage fcontext -a -t postgresql_db_t "/u01/data(/.*)?"
	sudo restorecon -R -v /u01/data
	
fi	
#sudo systemctl enable postgresql-${pg_version}
#sudo systemctl start postgresql-${pg_version}
#sudo systemctl status postgresql-${pg_version}
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql

if [[ $pg_version == "9.6" ]]; then 
	sudo -u root bash -c "tail -5 /u01/data/pg_log/postgresql-*.log"
else
	sudo -u root bash -c "tail -5 /u01/data/log/postgresql-*.log"
fi
