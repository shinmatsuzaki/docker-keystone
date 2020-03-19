## Use bash syntax
SHELL := /bin/bash

all:
		docker-compose up -d --build mysql_db keystone

ssh:
		mysql -u root -p

ps:
		docker-compose ps

clean:
		docker-compose down
