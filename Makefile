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
	# clean logs subfolders (only subfolders of logs/ but keep logs/ folder and .gitkeep file)
	find logs/ -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;