# docker build --no-cache -t shyym/monero-node --push .

FROM alpine AS build

ENV MONERO_TARBALL=monero-linux-x64-v0.18.3.4.tar.bz2
ENV MONERO_CHECKSUM=51ba03928d189c1c11b5379cab17dd9ae8d2230056dc05c872d0f8dba4a87f1d

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
