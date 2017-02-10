FROM ubuntu:16.04
RUN apt-get update && apt-get -y dist-upgrade
ENV livegrep_version d7cb1154c0
ADD https://storage.googleapis.com/livegrep.appspot.com/builds/livegrep-$livegrep_version.tgz /livegrep.tgz

RUN tar -C / -xzvf /livegrep.tgz
RUN ln -nsf /livegrep-${livegrep_version} /livegrep
