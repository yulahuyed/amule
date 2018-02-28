FROM ubuntu:xenial

ENV CADDYPATH /home/amule/

RUN apt update
RUN apt install -y amule-daemon supervisor wget curl

RUN wget -O "caddy.tar.gz" "https://caddyserver.com/download/linux/amd64?plugins=http.filemanager&license=personal"
RUN tar zxvf caddy.tar.gz
RUN mv caddy /usr/bin/
RUN rm -rf ./init

# Add startup script
RUN mkdir -p /home/amule/.aMule

ADD amule.sh /home/amule/amule.sh

ADD Caddyfile /etc/Caddyfile

RUN chmod -R 777 /home/amule

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp 8080/tcp

CMD ["/home/amule/amule.sh"]

