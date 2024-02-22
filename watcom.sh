#! /bin/sh
docker run -it --rm -v $(PWD):/work amura/openwatcom-v2 "$@"
