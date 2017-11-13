#/bin/bash

arm-linux-gnueabi-as -o $1.o $1.s
arm-linux-gnueabi-ld -o $1 $1.o
./$1