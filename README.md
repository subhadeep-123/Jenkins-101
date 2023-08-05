# Jenkins-101

Jenkins Master node is deployed using a custom Docker image based on jenkins/jenkins:lts. In this setup, the Jenkins container is mounted to the Docker Daemon socket of the host machine. This arrangement enables us to seamlessly run and build Docker images within the Jenkins Master node by leveraging the exposed Docker socket.

* Update, Upgrade Server and Clean Server
```
sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean
```

* Install Docker
```
sudo curl -sSL https://get.docker.com/ | sh
```

* Make Jenkins custom Dockerfile

```
FROM jenkins/jenkins:lts
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get -y install docker-ce
RUN usermod -aG docker jenkins
```

* Build Jenkins Docker Image

```
docker build -t jenkins-master-dind:latest
```

Run Jenkins Docker Image

```
docker run \
  --name jenkins 
  -it 
  -p 8080:8080 -p 50000:50000 
  -v /var/run/docker.sock:/var/run/docker.sock 
  -v jenkins_home:/var/jenkins_home 
  -d jenkins-master-dind:latest
```