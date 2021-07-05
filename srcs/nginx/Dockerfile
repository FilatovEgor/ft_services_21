FROM alpine:3.11.6

RUN apk update
RUN apk add nginx openssl openssh-server

COPY ./srcs/index.html /var/www/localhost/htdocs
COPY ./srcs/index.css /var/www/localhost/htdocs
COPY ./srcs/21.jpg /var/www/localhost/htdocs
COPY ./srcs/setup.sh /tmp/

RUN mkdir -p /ssl/
RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /ssl/cert.key -out /ssl/cert.crt -days 365 -subj '/C=RU/ST=RU/L=Moscow/O=School21/CN=tcarlena'
RUN echo 'Welcome to SSH ft_services by tcarlena' > /etc/motd

EXPOSE 80 443 22

ENTRYPOINT ["/tmp/setup.sh"]
