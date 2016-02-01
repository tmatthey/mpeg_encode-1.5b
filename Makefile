# 
# Copyright (c) 1995 The Regents of the University of California.
# All rights reserved.
# 
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement is
# hereby granted, provided that the above copyright notice and the following
# two paragraphs appear in all copies of this software.
# 
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
# CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
# 

#  
#  $Header: /n/video/199/eyhung/encode/RCS/Makefile,v 1.7 1995/02/02 02:25:51 eyhung Exp $
# 

##############################################################################
#
# Configurable items
#

################################################################
# PROFILING # use -pg or -p if and only if you want to profile #
################################################################
PROFLAG =

##############
# JPEG STUFF #
##############
JPEG_LIB = -ljpeg
JPEG_DIR = -I/user/include/
JPEG_LIB_DIR = -L/usr/lib/x86_64-linux-gnu/
MP_JPEG_OBJS = jpeg.o
MP_JPEG_SRCS = jpeg.c

####################################################################
# DEBUGGING # use -g if and only if you want to debug, else use -O #
####################################################################
#DEBUGFLAG = -g 
DEBUGFLAG = -O

###############################################################################
# MISSING PROTOTYES # use -DMISSING_PROTOS if your standard headers are wrong #
###############################################################################
PROTOFLAG = 
#PROTOFLAG = -DMISSING_PROTOS

#################
# INCLUDE FILES # 
#################
INCLUDEDIR = -Iheaders  $(JPEG_DIR)

############################################################################
# LIBRARIES # specify library directories; need jpg lib and maybe pbm	   #
############################################################################
#LIBDIRS = -L$(PBMLIBDIR) $(JPEG_LIB_DIR)
LIBDIRS = $(JPEG_LIB_DIR)

#####################################################################
# COMPILER # specify compiler; should be ANSI-compliant if possible #
#####################################################################
CC = cc

################################################
# MAKE # command to use for the "make" command #
################################################
MAKE = make

###################################################
# COMPILER FLAGS # modify for different compilers #
###################################################
# use -DLONG_32 iff
#	1) long's are 32 bits and
#	2) int's are not
#
# if you don't have <netinet/in.h> then you must define one of the following
#     -DFORCE_BIG_ENDIAN
#     -DFORCE_LITTLE_ENDIAN
#
# if you are using a non-ANSI compiler, then use:
#	-DNON_ANSI_COMPILER
#
# one other option:
#	-DHEINOUS_DEBUG_MODE
#
# listed below are some suggested CFLAG lines for various compilers
# 

#	gcc
CFLAGS	      =  $(INCLUDEDIR) $(DEBUGFLAG) -Wall -Wmissing-prototypes $(PROFLAG) $(PROTOFLAG)

#	gcc-strict
#CFLAGS	      =  $(INCLUDEDIR) $(DEBUGFLAG) -pedantic -Wall -Waggregate-return -Wtraditional -Wshadow -Wpointer-arith -Wno-parentheses -Wwrite-strings -Wconversion -Wcast-qual -Wcast-align -Wnested-externs -Wuninitialized -Wmissing-prototypes $(PROFLAG) $(PROTOFLAG)

#	SUN cc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG) -DNON_ANSI_COMPILER

#	HP cc
# CFLAGS = -Ae $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG)

#	HP gcc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG)

#	DEC ALPHA cc
#CFLAGS = $(INCLUDEDIR) -Olimit 1200 $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG)

#	DEC Ultrix gcc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) -Wall -Wmissing-prototypes $(PROFLAG) $(PROTOFLAG) -DMIPS

# 	SGI cc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG) -cckr -DIRIX

#	Intel-based SVR4.0 cc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG) -DLONG_32 -DSVR4 -DSYSV386

#	Intel-based SCO Unix
#CFLAGS =  $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG) -Dsco -m486

# linux CFLAGS
CFLAGS  = $(INCLUDEDIR) -fomit-frame-pointer -ffast-math -finline-functions $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG)  -DSYSV -DLINUX

#	IBM RS/6000 cc
#CFLAGS = $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG)

# DOS
#CFLAGS        =  $(INCLUDEDIR) $(DEBUGFLAG) -O1 -DSYSV -DFORCE_LITTLE_ENDIAN -w-rvl -w-rch -w-eff -w-ccc -w-par -w-use -w-aus -w-pro $(PROFLAG) $(PROTOFLAG)


#########################################################################
# LIBRARIES # same for most machines; may need to add stuff for sockets #
#########################################################################
#	this works for most machines
LIBS = $(JPEG_LIB) -lm

#	Solaris
#LIBS = $(JPEG_LIB) -lm -lsocket -lnsl

#	Intel-based SVR4.0
#LIBS = $(JPEG_LIB) -lm -lsocket -lnsl -lgen

#	Intel-based SCO Unix
#LIBS = $(JPEG_LIB) -lX11 -lsocket -lmalloc -lPW -lc_s -lm 


###############
# OTHER STUFF #
###############
#PURIFY = purify -cache-dir=/tmp
PURIFY =

#
# End of configurable options.  Just type make and have fun.
##############################################################################

MP_BASE_OBJS = mfwddct.o postdct.o huff.o bitio.o mheaders.o
MP_BASE_SRCS = mfwddct.c postdct.c huff.c bitio.c mheaders.c
MP_ENCODE_OBJS = iframe.o pframe.o bframe.o psearch.o bsearch.o block.o 
MP_ENCODE_SRCS = iframe.c pframe.c bframe.c psearch.c bsearch.c block.c 
MP_OTHER_OBJS = mpeg.o subsample.o param.o rgbtoycc.o \
	readframe.o combine.o jrevdct.o frame.o fsize.o frametype.o \
	libpnmrw.o specifics.o rate.o opts.o
MP_OTHER_SRCS = mpeg.c subsample.c param.c rgbtoycc.c \
	readframe.c combine.c jrevdct.c frame.c fsize.c frametype.c \
	libpnmrw.c specifics.c rate.c opts.c
MP_PARALLEL_OBJS = parallel.o
MP_PARALLEL_SRCS = parallel.c
MP_ALL_SRCS = $(MP_BASE_SRCS) $(MP_OTHER_SRCS) $(MP_ENCODE_SRCS) \
	      $(MP_PARALLEL_SRCS) $(MP_JPEG_SRCS) main.c
MP_ALL_OBJS = $(MP_BASE_OBJS) $(MP_OTHER_OBJS) $(MP_ENCODE_OBJS) \
	      $(MP_PARALLEL_OBJS) $(MP_JPEG_OBJS) main.o
MP_INCLUDE = mproto.h mtypes.h huff.h bitio.h
MP_MISC = Makefile huff.table parse_huff.pl

all: mpeg_encode

#########
# TESTS #
#########

test:
	rm -f /tmp/ts.stat
	./mpeg_encode -stat /tmp/ts.stat ./tst/ts.param
#
#This is Ok if you have setenv ...
#	csh ./tst/diffscript /tmp/ts.stat ./tst/ts.stat /tmp/ts.mpg ./tst/ts.mpg
#Use this to see the movie ...
#	mpeg2play /tmp/ts.mpg
#


testd:
	rm -f /tmp/tsd.stat
	./mpeg_encode -stat /tmp/tsd.stat ./tst/tsd.param
	csh ./tst/diffscript /tmp/tsd.stat ./tst/tsd.stat /tmp/tsd.mpg ./tst/tsd.mpg

test_all: test testd

############
# BINARIES #
############

mpeg_encode: $(MP_ALL_OBJS)
	$(PURIFY) $(CC) $(CFLAGS) -o $@ $(MP_ALL_OBJS) $(LIBDIRS) $(LIBS)

profile: $(MP_ALL_OBJS)
	$(PURIFY) $(CC) -Bstatic -pg $(CFLAGS) -o $@ $(MP_ALL_OBJS) $(LIBDIRS) $(LIBS)

#########
# OTHER #
#########

# make JPEG compile itself
#
#jpeg/libjpeg.a:
#	(cd jpeg; $(MAKE) libjpeg.a)
#

#
# Perl is necessary if you want to modify the Huffman RLE encoding table.
#
PERL = perl

# The following stuff is for the Huffman encoding tables.  It's commented-out
# because you probably don't want to change this.  If you do, then uncommment
# it.
#
# huff.h: huff.c
#
# huff.c: parse_huff.pl huff.table
#	$(PERL) parse_huff.pl huff.table

# Install stuff
DESTDIR = /opt/mpeg_encode
BINDIR  = $(DESTDIR)/bin/X11
LIBDIR  = $(DESTDIR)/lib/X11
MANDIR  = $(DESTDIR)/man/man1

headers.o: headers.c
	$(CC) $(CFLAGS) -c headers.c

depend: huff.c
	makedepend -- $(CFLAGS) -- $(MP_ALL_SRCS)

wc:;		wc -l *.[ch] headers/*.h *.pl *.table
ci:;		ci -l $(MP_ALL_SRCS) $(MP_INCLUDE) $(MP_MISC)
tags: $(MP_ALL_SRCS)
	ctags -t $(MP_ALL_SRCS)
	ctags -f TAGS -t $(MP_ALL_SRCS) headers/*.h

new:
	rm -f *.o core *~ gmon.out
	$(MAKE) depend

clean:
	-rm -f mpeg_encode *.o core *~ gmon.out
	$(MAKE) depend
	-$(MAKE) tags

install: all
	mkdir -p -m 755 $(DESTDIR) $(BINDIR) $(LIBDIR) \
                        $(LIBDIR)/examples $(MANDIR)
	cp mpeg_encode $(BINDIR)
	chmod 755 $(BINDIR)/mpeg_encode
	cp docs/mpeg_encode.1 $(MANDIR)
	chmod 644 $(MANDIR)/mpeg_encode.1
	cp docs/users-guide.ps $(LIBDIR)
	chmod 644 $(LIBDIR)/users-guide.ps
	cp examples/*.param $(LIBDIR)/examples
	chmod 644 $(LIBDIR)/examples/*

#
# WARNING: this assumes you're using GNU indent...
#
indent:;	indent -T FILE -T int8 -T int16 -T int32 -T uint8 -T uint16 -T uint32  -T BitBucket -T MpegFrame -T Block -T FlatBlock $(MP_ALL_SRCS)

spotless: clean	
	rm -f huff.c huff.h *.pure.a
	cd jpeg; $(MAKE) clean

##############################################################################
# DO NOT DELETE THIS LINE -- make depend depends on it.

mfwddct.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
mfwddct.o: /usr/include/stdc-predef.h /usr/include/libio.h
mfwddct.o: /usr/include/_G_config.h /usr/include/wchar.h
mfwddct.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
mfwddct.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
mfwddct.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
mfwddct.o: /usr/include/malloc.h headers/ansi.h headers/general.h
mfwddct.o: headers/dct.h headers/mtypes.h headers/opts.h
postdct.o: /usr/include/assert.h /usr/include/features.h
postdct.o: /usr/include/stdc-predef.h headers/all.h /usr/include/stdio.h
postdct.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
postdct.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
postdct.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
postdct.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
postdct.o: /usr/include/malloc.h headers/ansi.h headers/general.h
postdct.o: headers/mtypes.h headers/dct.h headers/bitio.h huff.h
postdct.o: headers/postdct.h headers/opts.h
huff.o: headers/mtypes.h headers/general.h headers/dct.h headers/ansi.h
huff.o: huff.h
bitio.o: /usr/include/assert.h /usr/include/features.h
bitio.o: /usr/include/stdc-predef.h /usr/include/unistd.h
bitio.o: /usr/include/getopt.h headers/all.h /usr/include/stdio.h
bitio.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
bitio.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
bitio.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
bitio.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
bitio.o: /usr/include/malloc.h headers/ansi.h headers/general.h
bitio.o: headers/byteorder.h /usr/include/netinet/in.h /usr/include/stdint.h
bitio.o: /usr/include/endian.h headers/bitio.h headers/mtypes.h headers/dct.h
mheaders.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
mheaders.o: /usr/include/stdc-predef.h /usr/include/libio.h
mheaders.o: /usr/include/_G_config.h /usr/include/wchar.h
mheaders.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
mheaders.o: /usr/include/memory.h /usr/include/string.h
mheaders.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
mheaders.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
mheaders.o: headers/general.h headers/bitio.h headers/frames.h
mheaders.o: headers/mtypes.h headers/dct.h headers/mheaders.h headers/frame.h
mpeg.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
mpeg.o: /usr/include/stdc-predef.h /usr/include/libio.h
mpeg.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
mpeg.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
mpeg.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
mpeg.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
mpeg.o: headers/ansi.h headers/general.h /usr/include/errno.h
mpeg.o: /usr/include/unistd.h /usr/include/getopt.h headers/mtypes.h
mpeg.o: headers/dct.h headers/frames.h headers/mheaders.h headers/bitio.h
mpeg.o: headers/frame.h headers/search.h headers/mpeg.h headers/prototypes.h
mpeg.o: headers/parallel.h headers/param.h headers/readframe.h
mpeg.o: headers/fsize.h headers/rate.h
subsample.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
subsample.o: /usr/include/stdc-predef.h /usr/include/libio.h
subsample.o: /usr/include/_G_config.h /usr/include/wchar.h
subsample.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
subsample.o: /usr/include/memory.h /usr/include/string.h
subsample.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
subsample.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
subsample.o: headers/general.h headers/mtypes.h headers/dct.h
subsample.o: headers/frames.h headers/mheaders.h headers/bitio.h
subsample.o: headers/frame.h headers/prototypes.h
param.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
param.o: /usr/include/stdc-predef.h /usr/include/libio.h
param.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
param.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
param.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
param.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
param.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
param.o: headers/mpeg.h headers/frame.h headers/search.h headers/prototypes.h
param.o: headers/parallel.h headers/bitio.h headers/param.h
param.o: headers/readframe.h headers/fsize.h headers/frames.h
param.o: headers/mheaders.h headers/jpeg.h /usr/include/ctype.h
param.o: /usr/include/endian.h headers/rate.h headers/opts.h
rgbtoycc.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
rgbtoycc.o: /usr/include/stdc-predef.h /usr/include/libio.h
rgbtoycc.o: /usr/include/_G_config.h /usr/include/wchar.h
rgbtoycc.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
rgbtoycc.o: /usr/include/memory.h /usr/include/string.h
rgbtoycc.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
rgbtoycc.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
rgbtoycc.o: headers/general.h headers/frame.h headers/mtypes.h headers/dct.h
rgbtoycc.o: headers/fsize.h headers/rgbtoycc.h
readframe.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
readframe.o: /usr/include/stdc-predef.h /usr/include/libio.h
readframe.o: /usr/include/_G_config.h /usr/include/wchar.h
readframe.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
readframe.o: /usr/include/memory.h /usr/include/string.h
readframe.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
readframe.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
readframe.o: headers/general.h /usr/include/errno.h /usr/include/ctype.h
readframe.o: /usr/include/endian.h /usr/include/unistd.h
readframe.o: /usr/include/getopt.h headers/mtypes.h headers/dct.h
readframe.o: headers/frames.h headers/mheaders.h headers/bitio.h
readframe.o: headers/frame.h headers/prototypes.h headers/parallel.h
readframe.o: headers/param.h headers/readframe.h headers/fsize.h
readframe.o: headers/rgbtoycc.h headers/jpeg.h headers/opts.h
combine.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
combine.o: /usr/include/stdc-predef.h /usr/include/libio.h
combine.o: /usr/include/_G_config.h /usr/include/wchar.h
combine.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
combine.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
combine.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
combine.o: /usr/include/malloc.h headers/ansi.h headers/general.h
combine.o: /usr/include/errno.h headers/mtypes.h headers/dct.h
combine.o: headers/frames.h headers/mheaders.h headers/bitio.h
combine.o: headers/frame.h headers/search.h headers/mpeg.h
combine.o: headers/prototypes.h headers/parallel.h headers/param.h
combine.o: headers/readframe.h headers/fsize.h headers/combine.h
combine.o: /usr/include/unistd.h /usr/include/getopt.h
jrevdct.o: /usr/include/memory.h /usr/include/features.h
jrevdct.o: /usr/include/stdc-predef.h /usr/include/string.h
jrevdct.o: /usr/include/xlocale.h headers/all.h /usr/include/stdio.h
jrevdct.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
jrevdct.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
jrevdct.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
jrevdct.o: /usr/include/malloc.h headers/ansi.h headers/general.h
jrevdct.o: headers/dct.h
frame.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
frame.o: /usr/include/stdc-predef.h /usr/include/libio.h
frame.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
frame.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
frame.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
frame.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
frame.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
frame.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
frame.o: headers/fsize.h
fsize.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
fsize.o: /usr/include/stdc-predef.h /usr/include/libio.h
fsize.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
fsize.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
fsize.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
fsize.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
fsize.o: headers/ansi.h headers/general.h headers/fsize.h headers/dct.h
frametype.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
frametype.o: /usr/include/stdc-predef.h /usr/include/libio.h
frametype.o: /usr/include/_G_config.h /usr/include/wchar.h
frametype.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
frametype.o: /usr/include/memory.h /usr/include/string.h
frametype.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
frametype.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
frametype.o: headers/general.h headers/prototypes.h headers/frame.h
frametype.o: headers/mtypes.h headers/dct.h headers/frames.h
frametype.o: headers/mheaders.h headers/bitio.h headers/param.h
libpnmrw.o: /usr/include/stdlib.h /usr/include/features.h
libpnmrw.o: /usr/include/stdc-predef.h /usr/include/alloca.h
libpnmrw.o: /usr/include/errno.h /usr/include/stdio.h /usr/include/libio.h
libpnmrw.o: /usr/include/_G_config.h /usr/include/wchar.h headers/libpnmrw.h
libpnmrw.o: /usr/include/malloc.h /usr/include/string.h
libpnmrw.o: /usr/include/xlocale.h
specifics.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
specifics.o: /usr/include/stdc-predef.h /usr/include/libio.h
specifics.o: /usr/include/_G_config.h /usr/include/wchar.h
specifics.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
specifics.o: /usr/include/memory.h /usr/include/string.h
specifics.o: /usr/include/xlocale.h /usr/include/limits.h /usr/include/time.h
specifics.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
specifics.o: headers/general.h headers/mtypes.h headers/dct.h
specifics.o: headers/frames.h headers/mheaders.h headers/bitio.h
specifics.o: headers/frame.h headers/fsize.h headers/specifics.h
specifics.o: headers/prototypes.h
rate.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
rate.o: /usr/include/stdc-predef.h /usr/include/libio.h
rate.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
rate.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
rate.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
rate.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
rate.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
rate.o: headers/bitio.h headers/frames.h headers/mheaders.h headers/frame.h
rate.o: headers/prototypes.h headers/param.h headers/fsize.h
rate.o: headers/postdct.h headers/mpeg.h headers/parallel.h headers/rate.h
opts.o: /usr/include/stdio.h /usr/include/features.h
opts.o: /usr/include/stdc-predef.h /usr/include/libio.h
opts.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
opts.o: /usr/include/alloca.h /usr/include/string.h /usr/include/xlocale.h
opts.o: headers/opts.h headers/general.h headers/ansi.h headers/mtypes.h
opts.o: headers/dct.h /usr/include/malloc.h /usr/include/math.h
iframe.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
iframe.o: /usr/include/stdc-predef.h /usr/include/libio.h
iframe.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
iframe.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
iframe.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
iframe.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
iframe.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
iframe.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
iframe.o: headers/prototypes.h headers/mpeg.h headers/param.h headers/fsize.h
iframe.o: headers/parallel.h headers/postdct.h headers/rate.h headers/opts.h
pframe.o: /usr/include/assert.h /usr/include/features.h
pframe.o: /usr/include/stdc-predef.h headers/all.h /usr/include/stdio.h
pframe.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
pframe.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
pframe.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
pframe.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
pframe.o: /usr/include/malloc.h headers/ansi.h headers/general.h
pframe.o: headers/mtypes.h headers/dct.h headers/bitio.h headers/frames.h
pframe.o: headers/mheaders.h headers/frame.h headers/prototypes.h
pframe.o: headers/param.h headers/fsize.h headers/postdct.h headers/mpeg.h
pframe.o: headers/parallel.h headers/rate.h headers/opts.h
bframe.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
bframe.o: /usr/include/stdc-predef.h /usr/include/libio.h
bframe.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
bframe.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
bframe.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
bframe.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
bframe.o: headers/ansi.h headers/general.h /usr/include/assert.h
bframe.o: headers/mtypes.h headers/dct.h headers/bitio.h headers/frames.h
bframe.o: headers/mheaders.h headers/frame.h headers/prototypes.h
bframe.o: headers/fsize.h headers/param.h headers/postdct.h headers/rate.h
bframe.o: headers/opts.h
psearch.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
psearch.o: /usr/include/stdc-predef.h /usr/include/libio.h
psearch.o: /usr/include/_G_config.h /usr/include/wchar.h
psearch.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
psearch.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
psearch.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
psearch.o: /usr/include/malloc.h headers/ansi.h headers/general.h
psearch.o: headers/mtypes.h headers/dct.h headers/frames.h headers/mheaders.h
psearch.o: headers/bitio.h headers/frame.h headers/search.h
psearch.o: headers/prototypes.h headers/fsize.h headers/param.h
bsearch.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
bsearch.o: /usr/include/stdc-predef.h /usr/include/libio.h
bsearch.o: /usr/include/_G_config.h /usr/include/wchar.h
bsearch.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
bsearch.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
bsearch.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
bsearch.o: /usr/include/malloc.h headers/ansi.h headers/general.h
bsearch.o: headers/mtypes.h headers/dct.h headers/frames.h headers/mheaders.h
bsearch.o: headers/bitio.h headers/frame.h headers/search.h headers/fsize.h
block.o: headers/all.h /usr/include/stdio.h /usr/include/features.h
block.o: /usr/include/stdc-predef.h /usr/include/libio.h
block.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/stdlib.h
block.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
block.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
block.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
block.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
block.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
block.o: headers/prototypes.h headers/fsize.h headers/opts.h
block.o: headers/postdct.h
parallel.o: /usr/include/time.h /usr/include/features.h
parallel.o: /usr/include/stdc-predef.h /usr/include/xlocale.h
parallel.o: /usr/include/netinet/in.h /usr/include/stdint.h
parallel.o: /usr/include/endian.h /usr/include/unistd.h /usr/include/getopt.h
parallel.o: /usr/include/netdb.h /usr/include/rpc/netdb.h
parallel.o: /usr/include/errno.h /usr/include/string.h /usr/include/signal.h
parallel.o: headers/all.h /usr/include/stdio.h /usr/include/libio.h
parallel.o: /usr/include/_G_config.h /usr/include/wchar.h
parallel.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
parallel.o: /usr/include/memory.h /usr/include/limits.h headers/libpnmrw.h
parallel.o: /usr/include/malloc.h headers/ansi.h headers/general.h
parallel.o: headers/param.h headers/mpeg.h headers/mtypes.h headers/dct.h
parallel.o: headers/frame.h headers/prototypes.h headers/parallel.h
parallel.o: headers/bitio.h headers/readframe.h headers/fsize.h
parallel.o: headers/combine.h headers/frames.h headers/mheaders.h
jpeg.o: /usr/include/stdio.h /usr/include/features.h
jpeg.o: /usr/include/stdc-predef.h /usr/include/libio.h
jpeg.o: /usr/include/_G_config.h /usr/include/wchar.h /usr/include/unistd.h
jpeg.o: /usr/include/getopt.h headers/all.h /usr/include/stdlib.h
jpeg.o: /usr/include/alloca.h /usr/include/math.h /usr/include/memory.h
jpeg.o: /usr/include/string.h /usr/include/xlocale.h /usr/include/limits.h
jpeg.o: /usr/include/time.h headers/libpnmrw.h /usr/include/malloc.h
jpeg.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
jpeg.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
jpeg.o: headers/prototypes.h headers/param.h headers/readframe.h
jpeg.o: headers/fsize.h headers/rgbtoycc.h headers/jpeg.h jpeg/jpeglib.h
jpeg.o: jpeg/jconfig.h jpeg/jmorecfg.h
main.o: /usr/include/assert.h /usr/include/features.h
main.o: /usr/include/stdc-predef.h headers/all.h /usr/include/stdio.h
main.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
main.o: /usr/include/stdlib.h /usr/include/alloca.h /usr/include/math.h
main.o: /usr/include/memory.h /usr/include/string.h /usr/include/xlocale.h
main.o: /usr/include/limits.h /usr/include/time.h headers/libpnmrw.h
main.o: /usr/include/malloc.h headers/ansi.h headers/general.h
main.o: headers/mtypes.h headers/dct.h headers/mpeg.h headers/frame.h
main.o: headers/search.h headers/prototypes.h headers/param.h
main.o: headers/parallel.h headers/bitio.h headers/readframe.h
main.o: headers/combine.h headers/frames.h headers/mheaders.h headers/jpeg.h
main.o: headers/specifics.h headers/opts.h
