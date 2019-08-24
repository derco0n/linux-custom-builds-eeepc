#!/bin/bash
#cp /boot/config-`uname -r` ./.config

<<<<<<< HEAD
case "$1" in
  aw17r4)
	echo "$1: Generating config for Dell Alienware 17R4"
	echo "Cleaning old config"
	make mrproper
	make clean

	#cp ../confs/.config-aw17 ./.config # Normal-config
	cp ../confs/.config-aw17_stripped_modules ./.config # config with stripped modules
	;;
  eeepc)
	echo "$1: Generating config for Asus EEEPC"
	echo "Cleaning old config"
	make mrproper
	make clean

	cp ../confs/.config_eeepc-strippedmodules ./.config
	;;
  *)
	echo "$1: Unknown Config. Aborting!"
	echo "Usage: make-config.sh <target>"
	echo "Possible targets:  \"aw17r4\", \"eeepc\""
	exit -1
	;;
esac
=======
cp ../confs/.config_eeepc-strippedmodules ./.config
#cp ../confs/.config_eeepc-slim5 ./.config
>>>>>>> origin/master

make oldconfig

#make localmodconfig #Just include currently loaded modules

<<<<<<< HEAD
echo "Loading menuconfig in case you want to change something..."
=======
>>>>>>> origin/master
make menuconfig

make prepare
