# Makefile — start mkdocs dev server with hot-reload
HOST ?= 127.0.0.1
PORT ?= 8000
ADDR := $(HOST):$(PORT)

.PHONY: serve
serve:
	mkdocs serve --dev-addr=$(ADDR) --livereload