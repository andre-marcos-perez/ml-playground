.PHONY: help
help: ## Show this help message
	@grep -h -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: env
env: ## Create virtual environment
	@python3 -m venv venv

.PHONY: format
format: ## Format code
	@isort src --profile black
	@black src

.PHONY: lint
lint: ## Lint code
	@flake8 src --count --show-source --statistics --max-line-length 88 --extend-ignore E203,E266,E501,W503,W291

.PHONY: build
build: ## Build
	@docker compose build
	@docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

.PHONY: start
start: ## Start
	@docker compose up -d
	@echo "Link: http://localhost:8888"

.PHONY: stop
stop: ## Stop
	@docker compose stop

.PHONY: prune
prune: ## Prune
	@docker compose down --volumes --remove-orphans
