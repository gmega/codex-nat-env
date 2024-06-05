.PHONY: codex images

codex:
	cd codex/nim-codex && $(MAKE)

images:
	docker compose build

all: codex images