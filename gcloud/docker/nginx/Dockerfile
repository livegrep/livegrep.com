FROM livegrep-base
RUN apt-get -y install nginx
ADD nginx.conf /livegrep/nginx.conf

ENTRYPOINT nginx -c /livegrep/nginx.conf
