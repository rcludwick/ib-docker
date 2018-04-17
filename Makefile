
build:
	docker-compose down
	docker-compose build
	docker-compose up

stop:
	docker-compose down

shell:
	docker exec -it ibgateway bash
