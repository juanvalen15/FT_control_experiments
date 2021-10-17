#!/usr/bin/env bash

make clean
make || exit 1

sudo ~/.local/bin/dynload 2 stop
sudo ~/.local/bin/dynload 0 stop

sudo ~/.local/bin/dynload 0 clear 0x20000 0x4000
sudo ~/.local/bin/dynload 0 clear 0x30000 0x4000


sudo ~/.local/bin/dynload 0 json state.json
sudo ~/.local/bin/dynload 2 json state.json
