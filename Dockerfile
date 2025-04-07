# docker buildx build --platform linux/amd64 -t shyym/monero-node --push .

FROM alpine AS build

ENV MONERO_TARBALL=monero-linux-x64-v0.18.4.0.tar.bz2
ENV MONERO_CHECKSUM=16cb74c899922887827845a41d37c7f3121462792a540843f2fcabcc1603993f

RUN apk add \
    bzip2 \
    tar

ADD https://downloads.getmonero.org/cli/${MONERO_TARBALL} .
RUN echo ${MONERO_CHECKSUM} ${MONERO_TARBALL} | sha256sum -c -
RUN tar -xjf ${MONERO_TARBALL} --wildcards '*/monerod'
RUN mv $(find -iname monerod | head -n1) /monerod

FROM alpine
COPY --from=build /monerod /monerod

RUN apk add \
    boost-chrono \
    boost-date_time \
    boost-filesystem \
    boost-program_options \
    boost-regex \
    boost-thread \
    gcompat \
    libusb \
    libzmq \
    hidapi \
    readline \
    unbound \
    ;

VOLUME /data
VOLUME /log
VOLUME /monerod.conf
EXPOSE 18080
EXPOSE 18081

CMD [ "/monerod", "--config-file", "/monerod.conf", "--non-interactive" ]
