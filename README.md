# Jenkins Setup

### Update, Upgrade Server and Clean Server
```
sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean
```

### Install Docker
```
sudo curl -sSL https://get.docker.com/ | sh
```

### Setup Jenkins

Make Dockerfile

```
FROM jenkins/jenkins:2.401.3-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
```

Create Docker Network
```
docker network create jenkins
```

Build Docker Image

```
docker build -t myjenkins-blueocean:2.401.3-1 .
```

Run Docker Image

```
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.401.3-1
```


### Configure Docker Socket for Cloud Agent
* `sudo nano /lib/systemd/system/docker.service`
* Replace existing `ExecStart` line with `ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock`
* sudo systemctl daemon-reload
* sudo service docker restart
* curl http://localhost:4243/version