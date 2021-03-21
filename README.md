# docker-footloose
Containerized Footloose

# Supported tags and respective `Dockerfile` links

  * [`0.6.3`, `latest`](https://github.com/felipefzdz/docker-footloose/blob/master/Dockerfile) 
  
## What is `footloose`

[`footloose`](https://github.com/weaveworks/footloose) is a CLI tool that creates containers that look like virtual machines

## Usage

    $ docker run -v /Users/alice/footloose-config:/footloose -v /var/run/docker.sock:/var/run/docker.sock --rm footloose:latest create

    time="2021-03-21T16:06:15Z" level=info msg="Docker Image: quay.io/footloose/ubuntu16.04 present locally"
    time="2021-03-21T16:06:15Z" level=info msg="Creating machine: cluster-node0 ..."

    $ docker ps
    CONTAINER ID   IMAGE                           COMMAND        CREATED         STATUS         PORTS                                                                   NAMES
    b92f614fef2d   quay.io/footloose/ubuntu16.04   "/sbin/init"   4 seconds ago   Up 4 seconds   0.0.0.0:8180->8180/tcp, 0.0.0.0:8888->8888/tcp, 0.0.0.0:51641->22/tcp   cluster-node0

    $ docker run -v /Users/alice/footloose-config:/footloose -v /var/run/docker.sock:/var/run/docker.sock --rm footloose:latest delete

    time="2021-03-21T16:07:16Z" level=info msg="Machine cluster-node0 is started, stopping and deleting machine..."

    $ docker ps
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES


## Rationale

`docker-footloose` is mostly intended for CI or testing automation where you don't want to require agents or local machines to have footloose installed.

## Design notes

Footloose ultimately creates docker containers. In order to containerized footloose (Inception incoming), the Dockerfile is based in Docker in Docker, dind, to be able to interact with the Docker API. As we want to create Docker containers in the host, and not on the contained derived from this image, we need to bind the host docker.sock when running the container `-v /var/run/docker.sock:/var/run/docker.sock`.

Footloose config where things like the OS image to be used or the exposed ports are defined should be located in a volume mapped to `/footloose` (that's the `WORKDIR` in the container), e.g. `-v /Users/alice/footloose-config:/footloose`. That means that whatever is writte into that folder will be available in the host, such as the `cluster-key` and `cluster-key.pub`. I didn't manage to get working things like `footloose ssh`, but it might be doable. If you need to do so, you could simply do `docker exec -it cluster-node0 bash`