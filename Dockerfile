FROM --platform=linux/amd64 debian:12-slim

LABEL maintainer="MURAMATSU Atsushi <amura@tomato.sakura.ne.jp>"

ENV WATCOM=/opt/watcom
ENV INCLUDE=$WATCOM/h EDPATH=$WATCOM/eddat WIPFC=$WATCOM/wipfc
ENV PATH=$WATCOM/binl64:$WATCOM/binl:/bin:/usr/bin
WORKDIR /work
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
		curl file unzip \
	&& curl -sLO https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/open-watcom-2_0-c-linux-x64 \
	&& curl -sLO https://github.com/open-watcom/open-watcom-v2/releases/download/Current-build/open-watcom-2_0-f77-linux-x64 \
	&& mkdir -p $WATCOM \
	&& cd $WATCOM \
	&& unzip -o /work/open-watcom-2_0-c-linux-x64 \
	&& unzip -o /work/open-watcom-2_0-f77-linux-x64 \
	&& rm -rf binp binw binnt binnt64 rdos nlm \
	&& cd $WATCOM/binl64 \
	&& /bin/sh -c 'for f in *; do if file $f | grep "ELF 64-bit"; then chmod +x $f; fi ; done' \
	&& cd $WATCOM/binl \
	&& /bin/sh -c 'for f in *; do if file $f | grep "ELF 32-bit"; then chmod +x $f; fi ; done' \
	&& cd /work \
	&& rm -f open-watcom-* \
	&& apt-get purge -y \
		curl unzip file \
	&& apt-get autoremove -y --purge && rm -rf /var/cache/apt

CMD [ "/bin/bash" ]

# docker build -t amura/openwatcom-v2 .
