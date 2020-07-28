FROM debian:latest as builder

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG UDPSPEEDER_VERSION=20200714.0
RUN UDP2RAW_VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/lhc70000/iina/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g' `

WORKDIR /app
RUN wget https://github.com/wangyu-/UDPspeeder/releases/download/$UDPSPEEDER_VERSION/speederv2_binaries.tar.gz \
  && tar -xzvf speederv2_binaries.tar.gz


FROM debian:stable-slim
COPY --from=builder /app/speederv2_amd64 /usr/local/bin
RUN chmod +x /usr/local/bin/speederv2_amd64

ENV LOCAL_ADDR 0.0.0.0:4096
ENV REMOTE_ADDR 127.0.0.1:8388
ENV PASSWORD ChangeMe!!!
ENV TIMEOUT 2
ENV FEC 2:4
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
