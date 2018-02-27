FROM alpine:edge

RUN apk --update add amule curl wget

# Add startup script
RUN mkdir -p /home/amule/.aMule

ADD amule.sh /home/amule/amule.sh

RUN chmod -R 777 /home/amule

RUN rm -rf /var/cache/apk/* && rm -rf /opt && apk del build-dependencies

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

CMD ["/home/amule/amule.sh"]

