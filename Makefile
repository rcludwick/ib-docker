
build:
	docker-compose down
	docker-compose build

stop:
	docker-compose down

shell:
	docker exec -it ibgateway bash

run: 
	docker-compose up
