run tag: volume-create (build tag)
	docker run --name kanboard-{{tag}} --volume kanboard-data:/var/www/html/data --rm -p 8080:8000 oscarcarlsson/wolfi-kanboard:{{tag}}

build tag:
	docker build --build-arg "VERSION={{tag}}" -t oscarcarlsson/wolfi-kanboard:{{tag}} .

exec tag:
	docker exec -it kanboard-{{tag}} /bin/sh

size tag:
	docker images --filter="reference=oscarcarlsson/wolfi-kanboard:{{tag}}" --format "{{{{ .Size }}"

pkgsearch:
	docker run --rm -it cgr.dev/chainguard/wolfi-base:latest /bin/sh

volume-create:
	docker volume create kanboard-data

volume-delete:
	docker volume rm kanboard-data
