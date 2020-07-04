FROM debian:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y vim wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV UDPSPEEDER_VERSION 20190121.0

WORKDIR /app/udpspeeder

RUN wget https://github.com/wangyu-/UDPspeeder/releases/download/$UDPSPEEDER_VERSION/speederv2_binaries.tar.gz \
  && tar -xzvf speederv2_binaries.tar.gz \
  && chmod +x speederv2_amd64 \
  && cp speederv2_amd64 /usr/local/bin \
  && rm -rf /app/udpspeeder

ENV LOCAL_ADDR 0.0.0.0:4096
ENV REMOTE_ADDR 127.0.0.1:8388 
ENV PASSWORD ChangeMe!!!
ENV TIMEOUT 8
ENV FEC 20:10
ENV MAXPACKAGE 200
ENV MODE 0
ENV ARGS -s #-c

CMD exec speederv2_amd64 \
    $ARGS \
    -l $LOCAL_ADDR \
    -r $REMOTE_ADDR \
    -k $PASSWORD \
    -f$FEC \
    -q $MAXPACKAGE \
    --mode $MODE \
    --timeout $TIMEOUT
  
