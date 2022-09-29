# cloned form nicolasdorier/docker-litecoin 
# use debian:strech-slim as base (slimmed down version)
FROM debian:stretch-slim
LABEL Name=LITECOIN Version=0.18.1
# create litecoin user and group
RUN groupadd -r litecoin && useradd -r -m -g litecoin litecoin

#  install the dependencies - ca certs, dirmngr,gosu,gpg,wget
# --no-install-recommends flag to disable recommended packages
# delete Storage area  /var/lib/apt/lists/*" for state information for each package resource to save space
RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

#set ENV vars to use to verify the litecoin tar  - checksum (sha256), PGP_key
ENV LITECOIN_VERSION 0.18.1
ENV LITECOIN_URL https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz
ENV LITECOIN_SHA256 ca50936299e2c5a66b954c266dcaaeef9e91b2f5307069b9894048acf3eb5751
ENV LITECOIN_ASC_URL https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-linux-signatures.asc
ENV LITECOIN_PGP_KEY FE3348877809386C

# install litecoin binaries; remove /tmp
# If "gpg: keyserver receive failed: Server indicated a failure" then make sure your name resolution works...you can set to Google DNS "nameserver 8.8.8.8" in your /etc/resolv.conf   
RUN set -ex \
	&& cd /tmp \
	&& wget -qO litecoin.tar.gz "$LITECOIN_URL" \
	&& echo "$LITECOIN_SHA256 litecoin.tar.gz" | sha256sum -c - \
	&& gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$LITECOIN_PGP_KEY" \
	&& wget -qO litecoin.asc "$LITECOIN_ASC_URL" \
	&& gpg --verify litecoin.asc \
	&& tar -xzvf litecoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory "/data" and set volume
# change ownership to litecoin:litecoin
# create soft link and change its ownership to litecoin:litecoin
ENV LITECOIN_DATA /data
RUN mkdir "$LITECOIN_DATA" \
	&& chown -R litecoin:litecoin "$LITECOIN_DATA" \
	&& ln -sfn "$LITECOIN_DATA" /home/litecoin/.litecoin \
	&& chown -h litecoin:litecoin /home/litecoin/.litecoin
VOLUME /data

#copy docker-entrypoint to image and run entypoint.sh (de-elavate from ROOT to litecoin user)
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

#expose following ports
EXPOSE 9332 9333 19335 19332 19444 19332
# start litecoin deamon
CMD ["litecoind"]