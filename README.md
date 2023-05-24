# stormcrawler-docker

Resources for running StormCrawler in Docker containers.

The docker compose file runs URFrontier; if you want to use Elasticsearch instead, un/comment the corresponding sections in the docker-compose.yml file accordingly. 

## Prerequisites
- Docker
- Docker-compose

# To build or not to build

If you don't have Java 11 JDK and Apache Maven installed on your computer, you will need to build a custom Docker image to extend the one for Apache Storm with `docker build -t digitalpebble/storm_maven:2.4.0-temurin .`. 
This way, you will be able to build in a Docker container the JAR file needed by StormCrawler (see below).

Otherwise, simply remove or comment out the _builder_ container in the compose file.

# Instructions

Make a directory with `mkdir crawldata`

Start the services, run `docker-compose up -d`.

*** IF YOU ARE NOT BUILDING THE JAR LOCALLY ***

Start the _builder_ container

`docker-compose run builder bash`

this is used to build a topology with Maven and send it to the Storm cluster

Now that you are within the _builder_ container, 

```
alias mvn="mvn -Dmaven.repo.local=/crawldata/.repository"
cd /crawldata 
mvn archetype:generate -DarchetypeGroupId=com.digitalpebble.stormcrawler -DarchetypeArtifactId=storm-crawler-archetype -DarchetypeVersion=2.2 -DartifactId=crawler -DgroupId=com.digitalpebble -Dversion=1.0
```

then press Enter to confirm the parameters.

You can change the access rights for the _crawler_ directory so that its content can be modified from outside the container.

`chmod a+rw -R crawler`

You should see a directory called _crawler_ in the _crawldata_ directory you created earlier on your machine. It contains the resources and code of the crawl topology. 

Back to the _builder_ container, compile with 

`cd crawler; mvn clean package`

*** IF YOU ARE BUILDING THE JAR LOCALLY ***

This is easy, all you have to do is 

```
mvn archetype:generate -DarchetypeGroupId=com.digitalpebble.stormcrawler -DarchetypeArtifactId=storm-crawler-archetype -DarchetypeVersion=2.2 -DartifactId=crawler -DgroupId=com.digitalpebble -Dversion=1.0
```

Follow the instructions in the README. 






