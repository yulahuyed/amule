FROM alpine:edge

RUN cat /etc/apk/repositories| sed 's@main@testing@g' > /testing && cat testing >> /etc/apk/repositories

RUN apk add amule curl wget --update

# Add startup script
RUN mkdir -p /home/amule/.aMule

ADD amule.sh /home/amule/amule.sh

RUN chmod -R 777 /home/amule

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

CMD ["/home/amule/amule.sh"]

