FROM storm:2.3.0

# Install maven
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y maven software-properties-common openjdk-11-jdk\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*  

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

USER storm
