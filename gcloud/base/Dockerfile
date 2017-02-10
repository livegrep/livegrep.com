FROM ubuntu:16.04
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install python-minimal
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-143.0.0-linux-x86_64.tar.gz /gcloud.tgz
RUN tar -C /usr/local -xzf /gcloud.tgz
RUN mkdir -p /usr/local/bin
RUN ln -nsf /usr/local/google-cloud-sdk/bin/* /usr/local/bin/
RUN mkdir -p /etc/ssh/
RUN echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> /etc/ssh/ssh_known_hosts

ENV livegrep_version 3d308220f8
ADD https://storage.googleapis.com/livegrep.appspot.com/builds/livegrep-$livegrep_version.tgz /livegrep.tgz

RUN tar -C / -xzvf /livegrep.tgz
RUN ln -nsf /livegrep-${livegrep_version} /livegrep
