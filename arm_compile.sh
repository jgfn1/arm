#/bin/bash

#Uncomment the lines below if you still do not have the necessary
#software to compile, emulate and run the ARM code:


# sudo apt-get install libc6-armel-cross libc6-dev-armel-cross
# sudo apt-get install binutils-arm-linux-gnueabi
# sudo apt-get install libncurses5-dev

arm-linux-gnueabi-as -o $1.o $1.s
arm-linux-gnueabi-ld -o $1 $1.o
./$1
