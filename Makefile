# Makefile for mobilesubstrate dylib for iPhone gcc compiler

PROJECTNAME:=GoagentToggle
CC:=arm-apple-darwin9-gcc
CPP:=arm-apple-darwin9-g++
LD=$(CC)
SDK = /var/toolchain/sys30

LDFLAGS = -arch arm -lobjc
LDFLAGS += -ObjC++
LDFLAGS += -lsubstrate
LDFLAGS += -framework Foundation 
LDFLAGS += -framework UIKit 
LDFLAGS += -framework CoreFoundation
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"
LDFLAGS += -bind_at_load
LDFLAGS += -multiply_defined suppress
LDFLAGS += -march=armv6
LDFLAGS += -mcpu=arm1176jzf-s 
LDFLAGS += -dynamiclib
#LDFLAGS += -init _$(PROJECTNAME)Initialize

CPPFLAGS = -I"$(SDK)/usr/include"
CPPFLAGS += -I"$(SDK)/dump"
CPPFLAGS += -g0 -O2
CPPFLAGS += -Wall -Werror
CPPFLAGS += -fobjc-exceptions
CPPFLAGS += -fobjc-call-cxx-cdtors

CFLAGS = -I"$(SDK)/usr/include"
CFLAGS += -I"$(SDK)/dump"
CFLAGS += -Wall
CFLAGS += -O2
CFLAGS += -fconstant-cfstrings
CFLAGS += -std=gnu99

OBJS:=$(PROJECTNAME).o

dylib_obj:=$(PROJECTNAME).dylib

all:	$(dylib_obj)

$(dylib_obj):	$(OBJS)
		$(LD) $(LDFLAGS) $^ -o $@ 
		ldid -S $(dylib_obj)

%.o:	%.m
		$(CC) -c $(CFLAGS) $< -o $@

clean:
		rm -f *.o $(dylib_obj)

install:	all
		cp $(dylib_obj) /User/Library/SBSettings/Toggles/Goagent/

uninstall:
		rm -f /User/Library/SBSettings/Toggles/Goagent/$(dylib_obj)

.PHONY: all install uninstall clean

