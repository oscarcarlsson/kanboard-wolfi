repo := "oscarcarlsson"
name := "kanboard-wolfi"

run tag: volume-create (build tag)
	docker run --name {{name}}-{{tag}} --volume {{name}}-data:/var/www/html/data --rm -p 8080:8000 {{repo}}/{{name}}:{{tag}}

build tag:
	docker build --build-arg "VERSION={{tag}}" -t {{repo}}/{{name}}:{{tag}} .

exec tag:
	docker exec -it {{name}}-{{tag}} /bin/sh

size tag:
	docker images --filter="reference={{repo}}/{{name}}:{{tag}}" --format "{{{{ .Size }}"

pkgsearch:
	docker run --rm -it cgr.dev/chainguard/wolfi-base:latest /bin/sh

volume-create:
	docker volume create {{name}}-data

volume-delete:
	docker volume rm {{name}}-data
