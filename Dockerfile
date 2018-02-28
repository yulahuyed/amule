FROM ubuntu:xenial

RUN apt update
RUN apt install -y amule-daemon supervisor wget curl unzip

RUN mkdir -p /home/amule/.aMule

RUN curl -o rclone-current-linux-amd64.zip https://downloads.rclone.org/rclone-current-linux-amd64.zip \
	&& unzip rclone-current-linux-amd64.zip \
	&& mv /rclone-*-linux-amd64/rclone /usr/bin/ \
	&& rm -rf /rclone-*-linux-amd64 \
&& rm rclone-current-linux-amd64.zip

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64.zip
RUN mv ngrok /home/amule
RUN rm ngrok-stable-linux-amd64.zip

RUN wget https://github.com/filebrowser/filebrowser/releases/download/v1.5.5/linux-amd64-filebrowser.tar.gz
RUN tar -xvzf linux-amd64-filebrowser.tar.gz
RUN mv ./filebrowser /home/amule/.aMule
RUN rm linux-amd64-filebrowser.tar.gz

# Add startup script

ADD amule.sh /home/amule/amule.sh

RUN chmod -R 777 /home/amule

WORKDIR /home/amule/.aMule

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp 8080/tcp

CMD ["/home/amule/amule.sh"]

