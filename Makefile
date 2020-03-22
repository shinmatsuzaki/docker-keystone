## Use bash syntax
SHELL := /bin/bash

all:
		docker-compose up --build mysql_db keystone

build:
		docker-compose build

ssh:
		docker exec -it  dockerkeystone_keystone_1 bash

ps:
		docker-compose ps && echo ""
		docker ps

clean:
		docker-compose down
