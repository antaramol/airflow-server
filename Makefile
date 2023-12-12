build:
	docker compose build airflow-init

up:
	docker compose up -d

down:
	docker compose down

clean:
	docker compose down --rmi all --volumes --remove-orphans
	docker system prune -af
	docker volume prune -f