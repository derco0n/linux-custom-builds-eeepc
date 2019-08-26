#!/bin/bash

DOWNLOADPATH="https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/"
KERNELV="linux-5.2.9"  # Change Archive as needed...

KERNELTAR="$KERNELV.tar"
KERNEL="$KERNELTAR.xz"
SIGN="$KERNELV.tar.sign" # Kernel Signature

wget $DOWNLOADPATH$KERNEL
echo "Unpacking $KERNEL"
#tar -Jxf $KERNEL
unxz $KERNEL

echo "Downloading GPG-Signatures for Signature-check"
gpg --locate-keys torvalds@kernel.org gregkh@kernel.org

echo "Getting Kernelsignature"
wget $DOWNLOADPATH$SIGN

if [ "$1" == "nogpg" ]; then
	echo "$1 is given. Skipping Signaturecheck"
else
	echo "checking signature"
	#CHECK=1

	gpg --trust-model tofu --verify $SIGN $KERNELTAR
	CHECK=$?
	#CHECK=$(gpg --trust-model tofu --verify $SIGN $KERNELTAR)

	#https://www.kernel.org/signature.html
	#Developer	Fingerprint
	#Linus Torvalds	ABAF 11C6 5A29 70B1 30AB  E3C4 79BE 3E43 0041 1886
	#Greg Kroah-Hartman	647F 2865 4894 E3BD 4571  99BE 38DB BDC8 6092 693E
	#Sasha Levin	E27E 5D8A 3403 A2EF 6687  3BBC DEA6 6FF7 9777 2CDC
	#Ben Hutchings	AC2B 29BD 34A6 AFDD B3F6  8F35 E7BF C8EC 9586 1109

	echo "GPG-Result is $CHECK"

	if [ $CHECK -ne 0 ]; then
		echo "Signature Check failed. Aborting."
		echo "This can happen if the kernel-tarball was modified after signing from the developers."
		echo "You can use \"nogpg\" to skip signature-checking."
		echo "Proceed at your own risk."
		exit 1
	else
		echo "Signature Check passed."
	fi
fi

echo "Untaring $KERNEL"
tar -xf $KERNELTAR

echo "Kernel: $KERNEL"

KDIR1=`echo "$KERNEL" | cut -f 1 -d '.'`
KDIR2=`echo "$KERNEL" | cut -f 2 -d '.'`
KDIR3=`echo "$KERNEL" | cut -f 3 -d '.'`

KERNELDIR="$KDIR1.$KDIR2.$KDIR3"
#KERNELDIR="$KDIR1.$KDIR2"

echo "Kerneldir: $KERNELDIR ..."

echo Linking Scripts into $KERNELDIR ...
ln -s ../build-kernel.sh ./$KERNELDIR/build-kernel.sh
#ln -s ../build-kernel.sh ./$KERNELDIR/build-kernel_cross_x86.sh
ln -s ../make-config.sh ./$KERNELDIR/make-config.sh
ln -s ../install-kernels.sh ./$KERNELDIR/install-kernels.sh
ln -s ../make-all.sh ./$KERNELDIR/make-all.sh
