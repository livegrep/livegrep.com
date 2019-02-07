FROM ubuntu:16.04
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install python-minimal
RUN mkdir -p /etc/ssh/
RUN echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> /etc/ssh/ssh_known_hosts

ARG livegrep_version
ADD https://storage.googleapis.com/livegrep.appspot.com/builds/livegrep-${livegrep_version}.tgz /livegrep.tgz

RUN tar -C / -xzvf /livegrep.tgz
RUN ln -nsf /livegrep-${livegrep_version} /livegrep
