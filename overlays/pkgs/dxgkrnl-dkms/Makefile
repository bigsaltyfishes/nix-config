# SPDX-License-Identifier: GPL-2.0
# Makefile for the hyper-v compute device driver (dxgkrnl).

obj-m	:= dxgkrnl.o
dxgkrnl-y := dxgmodule.o hmgr.o misc.o dxgadapter.o ioctl.o dxgvmbus.o dxgprocess.o  dxgsyncfile.o

all:
	$(MAKE) -C "$(KERNEL_DIR)" M="$(PWD)" modules

clean:
	$(MAKE) -C "$(KERNEL_DIR)" M="$(PWD)" clean