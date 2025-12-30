FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y lighttpd

CMD ["lighttpd", "-D", "-f", "/var/www/lighttpd.conf"]