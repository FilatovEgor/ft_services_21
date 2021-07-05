#!/bin/sh

openssl req -x509 -nodes -days 365 							\
			-newkey rsa:2048 -subj							\
			"/C=RU/ST=RU/L=Moscow/O=School21/CN=tcarlena"	\
			-keyout /etc/ssl/private/vsftpd.key				\
			-out /etc/ssl/certs/vsftpd.crt

mkdir -p /var/ftp
adduser -D -h /var/ftp $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

vsftpd /etc/vsftpd/vsftpd.conf
