# stormcrawler-docker

Resources for running StormCrawler in Docker containers.

The docker compose file runs URFrontier; if you want to use a different backend (e.g. Elasticsearch / OpenSearch) instead, add the required sections in the docker-compose.yml file accordingly.

This project does not cover the basics of StormCrawler. If you need to understand how StormCrawler works, please refer to the documentation [there](https://github.com/DigitalPebble/storm-crawler).

## Prerequisites
- Docker
- Docker-compose
- (optional) Apache Maven

First, you will need to build a custom Docker image to extend the one for Apache Storm with `docker build -t digitalpebble/storm_maven:2.6 .`. This will make it easier for you to launch the crawler using the containers.

Create a directory 'frontier' in the current directory with `mkdir -m 777 frontier`.

# Instructions

We will assume that you have a StormCrawler project available, if you do, you can copy its content to a _crawldata_ directory within the current one or modify the volume in the _runner_ definition in the docker-compose file

```
    volumes:
      - "./myexistingsetup:/crawldata"
``` 

If you don't, you can generate one using the Maven archetype

```
mvn archetype:generate -DarchetypeGroupId=com.digitalpebble.stormcrawler -DarchetypeArtifactId=storm-crawler-archetype -DarchetypeVersion=2.9 -DartifactId=crawldata -DgroupId=com.digitalpebble -Dversion=1.0
```

The command above will generate a StormCrawler setup in the directory 'crawldata'. Look at the README file generated and compile with `mvn clean package`.

Finally, start the services with `docker-compose up -d`.

---

*** IF YOU ARE DON'T HAVE A STORMCRAWLER SETUP AND NEITHER MAVEN NOR JAVA'***

*IMPORTANT* Make sure you give +rw access to any user on the _crawldata_ directory, this is done with `chmod -R a+rw crawldata`; otherwise the container won't be able to create any content in it.

Start the _runner_ container

`docker-compose run runner bash`

this is used to build a topology with Maven but also send it to the Storm cluster

Now that you are within the _runner_ container, you can run the command above *within the container*.

```
alias mvn="mvn -Dmaven.repo.local=/crawldata/.repository"
cd /crawldata 
mvn archetype:generate -DarchetypeGroupId=com.digitalpebble.stormcrawler -DarchetypeArtifactId=storm-crawler-archetype -DarchetypeVersion=2.9 -DartifactId=crawler -DgroupId=com.digitalpebble -Dversion=1.0
```

then press Enter to confirm the parameters.

You can change the access rights for the _crawler_ directory so that its content can be modified from outside the container.

`chmod a+rw -R crawler`

You should see a directory called _crawler_ in the _crawldata_ directory you created earlier on your machine. It contains the resources and code of the crawl topology. 

---

Now, whether the StormCrawler setup you will be using was preexisting, generated locally or within the _runner_ container, you should have it in _crawldata/crawler_.

To run the topology, go back to the _runner_ container (assuming you had left it) and call  

```
docker-compose run runner bash
cd /crawldata/crawler
alias mvn="mvn -Dmaven.repo.local=/crawldata/.repository"
```

then follow the instructions in the README file, the first one being to compile the uber jar with `mvn clean package`. Bear in mind that you might need to change the configuration of the topology and use the container names from the compose file (e.g. frontier).

You can close the _runner_ once the topology is launched in deployed mode. In local mode, you need to keep it open.







