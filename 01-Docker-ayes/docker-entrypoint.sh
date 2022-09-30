#!/bin/sh

# cloned from nicolasdorier github repo
# https://github.com/uphold/docker-litecoin-core/blob/master/0.18/docker-entrypoint.sh

set -e

# If 1st character of 1st arg is "-" the set litecoind to args
if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for litecoind"

  set -- litecoind "$@"
fi

# set datadir
if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "litecoind" ]; then
  mkdir -p "$LITECOIN_DATA"
  chmod 770 "$LITECOIN_DATA" || echo "Could not chmod $LITECOIN_DATA (may not have appropriate permissions)"
  chown -R litecoin "$LITECOIN_DATA" || echo "Could not chown $LITECOIN_DATA (may not have appropriate permissions)"

  echo "$0: setting data directory to $LITECOIN_DATA"

  set -- "$@" -datadir="$LITECOIN_DATA"
fi


# if UID="0" (root) and 1st arg litecoin or litecoin-cli or litecoin-tx then GOSU (switch user - deevalate)
if [ "$(id -u)" = "0" ] && ([ "$1" = "litecoind" ] || [ "$1" = "litecoin-cli" ] || [ "$1" = "litecoin-tx" ]); then
  set -- gosu litecoin "$@"
fi

exec "$@"