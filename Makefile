.PHONY: default

default: build

build:
	@ls src/deploy/composer.json
	@docker-compose build

start: build
	@docker-compose up -d

deploy: start
	@docker exec -it ministra_db /bin/bash -c "ls /var/lib/mysql/stalker_db/administrators.frm || cd /tmp/mysql/delta/ && ls -1v *.sql | xargs sed -n '/--/,/@UNDO/p' > /tmp/mysql/stalker_db.sql && mysql stalker_db < /tmp/mysql/stalker_db.sql"