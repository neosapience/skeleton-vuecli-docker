.PHONY: create install serve sh dist ps exec down ls open-browser

name := skeleton-vuecli
pwd := $(shell pwd)
version := v0.0.1
ui_ip = $(shell docker-compose ps | grep -o '0.0.0.0:[0-9]*->8000/tcp' | sed 's/->8000\/tcp//g')
devserver_ip = $(shell docker-compose ps | grep -o '0.0.0.0:[0-9]*->8080/tcp' | sed 's/->8080\/tcp//g')

# don't change the project name
create:
	@docker build . -t ${name}:env -f docker/Dockerfile
	@docker run --rm -it \
		-v ${pwd}/frontend:/opt/webapp \
		${name}:env \
		vue create app --preset neos

install:
	@docker build . -t ${name}:env -f docker/Dockerfile
	@docker run --rm -it -v ${pwd}/frontend/app:/opt/webapp/app ${name}:env yarn install

ls:
	@docker images ${name}

up:
	@docker-compose up

ps:
	@docker-compose ps

ui:
	open -a 'Google Chrome' http://${ui_ip}

dev-server:
	open -a 'Google Chrome' http://${devserver_ip}

exec:
	@docker-compose exec workzone bash

sh:
	@docker run --rm -it -v ${pwd}/frontend:/opt/webapp ${name}:env bash

open:
	@echo "please open the web page for vue app"

deploy:
	@docker build . -t ${name}:${version} -f docker/Dockerfile.dist

run-deploy:
	@docker run --rm -d -p 80 ${name}:${version}