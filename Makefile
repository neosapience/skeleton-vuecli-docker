.PHONY: create install serve sh dist ps exec down ls open-browser

name := skeleton-vuecli
pwd := $(shell pwd)
version := v0.0.1
up_url = $(shell docker-compose ps | grep -o '0.0.0.0:[0-9]*->8000/tcp' | sed 's/->8000\/tcp//g')

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

open-browser:
	open -a 'Google Chrome' http://${up_url}

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