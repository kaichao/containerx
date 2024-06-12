IMAGE_NAME:=kaichao/docker:dind-centos

build:
	DOCKER_BUILDKIT=1 docker build --network=host -t $(IMAGE_NAME) .

start:
	docker run --privileged -d --name dind-centos $(IMAGE_NAME)

run:
	docker exec -it dind-centos bash

push:
	docker push $(IMAGE_NAME)

pull:
	docker pull $(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME)
