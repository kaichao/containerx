IMAGE_NAME:=kaichao/docker:dind-debian

build:
	DOCKER_BUILDKIT=1 docker build --network=host -t $(IMAGE_NAME) .

start:
	docker run --privileged -d --network=host --name dind-debian $(IMAGE_NAME)

run:
	docker exec -it dind-debian bash

push:
	docker push $(IMAGE_NAME)

pull:
	docker pull $(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME)
