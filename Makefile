## Use bash syntax
SHELL := /bin/bash

all:
		docker-compose up --build mysql_db keystone

build:
		docker-compose build

ssh:
		mysql -u root -p

ps:
		docker-compose ps

clean:
		docker-compose down
