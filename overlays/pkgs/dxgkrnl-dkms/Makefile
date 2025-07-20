# SPDX-License-Identifier: GPL-2.0
# Makefile for the hyper-v compute device driver (dxgkrnl).

obj-m	:= dxgkrnl.o
dxgkrnl-y := dxgmodule.o hmgr.o misc.o dxgadapter.o ioctl.o dxgvmbus.o dxgprocess.o  dxgsyncfile.o

ccflags-y := -I$(src)/include

default:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD)

all:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD)

clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) clean

.PHONY: default all clean