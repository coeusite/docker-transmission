#!/usr/bin/env bash

export DEBIAN_FRONTEND='noninteractive' && \
apt-get update -qq && \
apt-get install -qqy --no-install-recommends wget ca-certificates\
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
file=https://github.com/ronggang/transmission-web-control/raw/master/release/tr-control-easy-install.sh && \
wget -O - $file | bash && \
apt-get clean
