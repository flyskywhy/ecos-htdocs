# PKG_INSTALL_DIR might need to be edited.  Right now it is set
# assuming that a user ran pkgconf.tcl in //c/ecos-work on Windows NT,
# or used the Configuration Tool with C:\ecos-work as a build-tree

PKG_INSTALL_DIR = //c/ecos-work/install

CFLAGS := -Wall -g -I${PKG_INSTALL_DIR}/include

LDFLAGS := -g -L$(PKG_INSTALL_DIR)/lib
LIBS := -Ttarget.ld -nostdlib

# start-sanitize-powerpc
CC = powerpc-eabi-gcc
LD = powerpc-eabi-gcc
# end-sanitize-powerpc
# start-sanitize-mn10300
CC = mn10300-elf-gcc
LD = mn10300-elf-gcc
# end-sanitize-mn10300
# start-sanitize-tx39
CC = mips-tx39-elf-gcc
LD = mips-tx39-elf-gcc
# end-sanitize-tx39


all: hello twothreads simple-alarm serial # instrument-sim instrument-msg

hello: hello.o
	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

twothreads: twothreads.o
	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

simple-alarm: simple-alarm.o
	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

serial: serial.o
	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

# start-sanitize-powerpc
#instrument-sim: instrument-sim.o
#	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

#instrument-msg: msg_driver.o instrument-main.o msg.o
#	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

#msg_driver.o: msg_driver.c msg.h
# end-sanitize-powerpc
