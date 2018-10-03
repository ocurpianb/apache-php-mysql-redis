FROM ubuntu:18.04

ENV LANG=C 
ENV TZ=Europe/Madrid

RUN apt-get update && \
	apt-get upgrade -y && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
	apt-get install apache2 -y && \
	apt-get install libapache2-mod-php php-mysql php-redis -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/log/dpkg.log /var/lib/apt /var/cache/apt && \
	ln -sf /dev/stdout /var/log/apache2/access.log && \
	ln -sf /dev/stderr /var/log/apache2/error.log && \ 
	sed -i -e 's/;session.save_path = .*/session.save_path = "tcp:\/\/redis"/' -i -e 's/session.save_handler = .*/session.save_handler = redis/' /etc/php/7.2/apache2/php.ini

COPY index.php /var/www/html/index.php

ENTRYPOINT ["/usr/sbin/apache2ctl" , "-D" , "FOREGROUND" ]
EXPOSE 	80
