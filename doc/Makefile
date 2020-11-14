.PHONY: help requirements requirements-dev requirements-deb lint test run

APP := k8s_diagram
WORKON_HOME ?= .venv
VENV_BASE := $(WORKON_HOME)/${APP}
VENV_ACTIVATE := $(VENV_BASE)/bin/activate
PYTHON := ${VENV_BASE}/bin/python3

.DEFAULT: help

darkblue = \033[34m
darkyellow = \033[33m
darkgreen = \033[32m
darkred = \033[31m
purple = \033[35m
cyan = \033[36m
white = \033[0m
help:
	@echo "Usage: make [TARGET ...]"
	@echo ""
	@egrep -h "##" $(MAKEFILE_LIST) | tail -n +8 | sed -e 's/\\$$//' | awk ' \
			BEGIN {FS = "[:=].*?#[#](|blue|purple|red|green|yellow) "}; \
			/##red/ { printf "$(darkred)%-30s$(white) %s\n", $$1, $$2; next} \
			/##green/ { printf "$(darkgreen)%-30s$(white) %s\n", $$1, $$2; next} \
			/##blue/ { printf "$(darkblue)%-30s$(white) %s\n", $$1, $$2; next} \
			/##purple/ { printf "$(purple)%-30s$(white) %s\n", $$1, $$2; next} \
			/##yellow/ { printf "$(darkyellow)%-30s$(white) %s\n", $$1, $$2; next} \
			/##/ { gsub("^##",""); printf "$(cyan)%-30s$(white) %s\n", $$1, $$2} \
			'
	@echo ""

venv:	##red Create Virtual ENV
venv:
	@if [ ! -d "$(VENV_BASE)" ]; then\
		virtualenv -p python3 $(VENV_BASE); \
	fi
##
requirements:	##blue Install pip requirements
requirements: venv
	@echo Installing pip software requirements
	@${PYTHON} -m pip install -r requirements.txt > /dev/null

requirements-dev:	##blue Install pip requirements
requirements-dev: venv
	@echo Installing pip development requirements
	@${PYTHON} -m pip install -r requirements-dev.txt > /dev/null

requirements-deb:	##blue Install debian packages requirements
requirements-deb:
	@echo Installing debian requirements
	@apt install $(cat requirements-deb.txt)
##
lint:	##yellow Run pycodestyle
lint: requirements-dev
	@echo Running linter
	@${PYTHON} -m pycodestyle .

test:	##yellow Run tests and show report
test: lint
	@echo Running tests
##
run:	##green Run project
run: requirements
	@${PYTHON} -m ${APP}
