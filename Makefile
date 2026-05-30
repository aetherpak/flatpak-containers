.DEFAULT_GOAL := help

.PHONY: setup lint help

##@ Bootstrap

setup: ## Install pre-commit hooks
	pre-commit install || uvx pre-commit install

##@ Quality

lint: ## Run pre-commit checks on all files
	pre-commit run --all-files || uvx pre-commit run --all-files

##@ Utilities

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	  /^[a-zA-Z0-9_/-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } \
	  /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)
