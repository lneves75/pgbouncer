VERSION=1.12.0

pgbouncer-$(VERSION).tar.gz:
	curl -fsSL -o pgbouncer-$(VERSION).tar.gz https://pgbouncer.github.io/downloads/files/$(VERSION)/pgbouncer-$(VERSION).tar.gz

build: pgbouncer-$(VERSION).tar.gz
	docker build --build-arg VERSION=$(VERSION) -t pgbouncer:$(VERSION) .

