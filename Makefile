NAME 			= stretch

SYSTEM_USER		= $(shell whoami)
DOCKER_CONFIG 	= $(shell echo $$HOME)/.docker
DB_PATH			= ./srcs/database

help: ## Display this help message
	clear
	@echo "${BLUE}\n\t=== Available commands ===${NC}"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' \
	$(MAKEFILE_LIST) | sort -r | \
	awk 'BEGIN {FS = ":.*?## "}; \
	{printf "$(GREEN)%-20s$(NC)$(BOLD) %s$(NC)\n", $$1, $$2}'

run: ## Run the project in detached mode
	@echo "${YELLOW}\t=== Running Project ===${NC}"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build
	@echo "${GREEN}\t=== Project Running ===${NC}"

status: ## Display status of networks, volumes, containers, and images
#	Networks
		@echo "$(BLUE)\t\t=== Docker Status ===$(NC)"
		@echo "$(BOLD)\nNetworks:$(NC)"
		@docker network ls
		
#	Volumes
		@echo "$(BOLD)\nVolumes:$(NC)"
		@docker volume ls

#	Containers
		@echo "$(BOLD)\nContainers:$(NC)"
		@docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

#	Images		
		@echo "$(BOLD)\nImages:$(NC)"
		@docker images
		@echo "$(BLUE)\n\t    === End of Docker Status ===$(NC)\n"

backup: ## Backup the database
	@echo "${YELLOW}\t=== Backup Database ===${NC}"
	@docker exec -it database pg_dump -U db_user -d postgres > \
	${DB_PATH}/backup.sql
	@echo "${GREEN}\t=== Backup Completed ===${NC}"

nuke: ## Remove all containers, networks, and volumes
	@echo "${YELLOW}\t === Purging Docker Resources === ${NC}"
	@echo "${RED}Warning: This action will remove all the system containers, networks, and volumes.${NC}"
	@read -p "Are you sure you want to continue?(y/N):" confirm; \
	if [ "$$confirm" != "y" ]; then \
		exit 1; \
	fi
	@if [ "$$(docker ps -aq)" ]; then \
		docker rm -f $$(docker ps -aq); \
	fi
	@if [ "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	@if [ "$$(docker images -q)" ]; then \
		docker rmi -f $$(docker images -q); \
	fi
	@if [ "$$(docker network ls -q)" ]; then \
		for network in $$(docker network ls -q); do \
			name=$$(docker network inspect --format='{{.Name}}' $$network); \
			if [ "$$name" != "bridge" ] && [ "$$name" != "host" ] && [ "$$name" != "none" ]; then \
				docker network rm $$network; \
			fi; \
		done; \
	fi
	@echo "${GREEN}\t===== Docker Resources Purged =====${NC}"

# Colors
NC		= \033[0m
RED		= \033[1;31m
BLUE	= \033[1;34m
BOLD	= \033[1m
GREEN	= \033[1;32m
YELLOW	= \033[1;33m