FROM alpine:3.19

RUN apk add --no-cache socat bash coreutils

COPY server.sh /server.sh
RUN chmod +x /server.sh

EXPOSE 80

CMD ["socat", "TCP-LISTEN:80,fork,reuseaddr", "EXEC:/server.sh"]
