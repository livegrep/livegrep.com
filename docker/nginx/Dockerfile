FROM livegrep/base
RUN apt-get -y install nginx
ADD nginx.conf /livegrep/nginx.conf

CMD nginx -c /livegrep/nginx.conf
