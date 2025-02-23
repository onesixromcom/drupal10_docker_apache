#!make

PROJECT_NAME = my-project
DRUPAL_ROOT=/drupal/
SERVER_ROOT=/drupal/web/

CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)
GATEWAY=$$(docker inspect -f "{{ (index .IPAM.Config 0).Gateway }}" $${PROJECT_NETWORK_ID}); \

SETTINGS='\
	export PROJECT_NAME=${PROJECT_NAME}; \
	export CURRENT_UID=${CURRENT_UID}; \
	export CURRENT_GID=${CURRENT_GID}; \
	export DOCKER_ENV="docker compose --project-name $${PROJECT_NAME}"; \
'

# Default docker commands.
DOCKER_UP=' \
	$${DOCKER_ENV} up --detach --build --remove-orphans  ; \
'

DOCKER_STOP=' \
	$${DOCKER_ENV} stop \
'

DOCKER_DOWN=' \
	$${DOCKER_ENV} down --remove-orphans \
'

DOCKER_REMOVE=' \
	$${DOCKER_ENV} rm \
'

DOCKER_EXEC_PHP=' \
	$${DOCKER_ENV} exec php-fpm bash \
'

DOCKER_EXEC_WEB=' \
	$${DOCKER_ENV} exec web sh \
'
DOCKER_EXEC_APACHE=' \
	$${DOCKER_ENV} exec web-apache sh \
'
DOCKER_EXEC_APACHE_LOGS=' \
	$${DOCKER_ENV} logs web-apache \
'

DOCKER_EXEC_DB=' \
	$${DOCKER_ENV} exec mariadb sh \
'

DEBUGGER_ON=' \
	$${DOCKER_ENV} exec --user root php-fpm docker-php-ext-enable xdebug; \
	$${DOCKER_ENV} restart php-fpm; \
	$${DOCKER_ENV} restart web  \
'

DEBUGGER_OFF=' \
	$${DOCKER_ENV} exec --user root php-fpm rm -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	$${DOCKER_ENV} restart php-fpm; \
	$${DOCKER_ENV} restart web  \
'

#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------

up:
	@bash -c $(SETTINGS)$(DOCKER_UP)

url:
	echo "http://${PROJECT_NAME}-web.docker.localhost"

sql:
	docker compose --project-name $(PROJECT_NAME) exec mariadb mysql -udrupal -pdrupal drupal

dump:
	docker compose --project-name $(PROJECT_NAME) exec php drush sql:dump > ./dumps/latest-$(DATE).sql

down:
	@bash -c $(SETTINGS)$(DOCKER_DOWN)

php:
	@bash -c $(SETTINGS)$(DOCKER_EXEC_PHP)

weba:
	@bash -c $(SETTINGS)$(DOCKER_EXEC_APACHE)

webal:
	@bash -c $(SETTINGS)$(DOCKER_EXEC_APACHE_LOGS)

db-import:
	docker compose --project-name $(PROJECT_NAME) exec -T mariadb mysql -udrupal -pdrupal drupal < ./dumps/dump.sql

# Enable Xdebug
xon:
	@bash -c $(SETTINGS)$(DEBUGGER_ON)

# Disable Xdebug
xoff:
	@bash -c $(SETTINGS)$(DEBUGGER_OFF)
