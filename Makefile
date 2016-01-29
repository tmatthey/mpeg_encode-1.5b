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
JPEG_DIR = -I/opt/jpeg-6/include/
JPEG_LIB_DIR = -L/opt/jpeg-6/lib
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
CFLAGS = -Ae $(INCLUDEDIR) $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG)

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
#CFLAGS  = $(INCLUDEDIR) -m486 -fomit-frame-pointer -ffast-math -finline-functions $(DEBUGFLAG) $(PROFLAG) $(PROTOFLAG) -DLONG_32 -DSYSV -DLINUX

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

mfwddct.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
mfwddct.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
mfwddct.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
mfwddct.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
mfwddct.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
mfwddct.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
mfwddct.o: headers/ansi.h headers/general.h headers/dct.h headers/mtypes.h
mfwddct.o: headers/opts.h
postdct.o: /usr/include/assert.h /usr/include/sys/stdsyms.h headers/all.h
postdct.o: /usr/include/stdio.h /usr/include/sys/types.h
postdct.o: /usr/include/sys/_inttypes.h /usr/include/sys/_null.h
postdct.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
postdct.o: /usr/include/sys/_wchar_t.h /usr/include/math.h
postdct.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
postdct.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
postdct.o: headers/general.h headers/mtypes.h headers/dct.h headers/bitio.h
postdct.o: huff.h headers/postdct.h headers/opts.h
huff.o: headers/mtypes.h headers/general.h headers/dct.h headers/ansi.h
huff.o: huff.h
bitio.o: /usr/include/assert.h /usr/include/sys/stdsyms.h headers/all.h
bitio.o: /usr/include/stdio.h /usr/include/sys/types.h
bitio.o: /usr/include/sys/_inttypes.h /usr/include/sys/_null.h
bitio.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
bitio.o: /usr/include/sys/_wchar_t.h /usr/include/math.h
bitio.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
bitio.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
bitio.o: headers/general.h headers/byteorder.h /usr/include/netinet/in.h
bitio.o: headers/bitio.h headers/mtypes.h headers/dct.h
mheaders.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
mheaders.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
mheaders.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
mheaders.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
mheaders.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
mheaders.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
mheaders.o: headers/ansi.h headers/general.h headers/bitio.h headers/frames.h
mheaders.o: headers/mtypes.h headers/dct.h headers/mheaders.h headers/frame.h
mpeg.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
mpeg.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
mpeg.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
mpeg.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h /usr/include/math.h
mpeg.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
mpeg.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
mpeg.o: headers/general.h /usr/include/time.h /usr/include/sys/_time_t.h
mpeg.o: /usr/include/errno.h /usr/include/sys/errno.h /usr/include/unistd.h
mpeg.o: /usr/include/sys/unistd.h headers/mtypes.h headers/dct.h
mpeg.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
mpeg.o: headers/search.h headers/mpeg.h headers/prototypes.h
mpeg.o: headers/parallel.h headers/param.h headers/readframe.h
mpeg.o: headers/fsize.h headers/rate.h /usr/include/sys/stat.h
subsample.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
subsample.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
subsample.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
subsample.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
subsample.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
subsample.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
subsample.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
subsample.o: headers/frames.h headers/mheaders.h headers/bitio.h
subsample.o: headers/frame.h headers/prototypes.h
param.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
param.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
param.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
param.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
param.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
param.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
param.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
param.o: headers/mpeg.h headers/frame.h headers/search.h headers/prototypes.h
param.o: headers/parallel.h headers/bitio.h headers/param.h
param.o: headers/readframe.h headers/fsize.h headers/frames.h
param.o: headers/mheaders.h headers/jpeg.h /usr/include/ctype.h
param.o: headers/rate.h headers/opts.h
rgbtoycc.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
rgbtoycc.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
rgbtoycc.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
rgbtoycc.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
rgbtoycc.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
rgbtoycc.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
rgbtoycc.o: headers/ansi.h headers/general.h headers/frame.h headers/mtypes.h
rgbtoycc.o: headers/dct.h headers/fsize.h headers/rgbtoycc.h
readframe.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
readframe.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
readframe.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
readframe.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
readframe.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
readframe.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
readframe.o: headers/ansi.h headers/general.h /usr/include/time.h
readframe.o: /usr/include/sys/_time_t.h /usr/include/errno.h
readframe.o: /usr/include/sys/errno.h /usr/include/ctype.h
readframe.o: /usr/include/unistd.h /usr/include/sys/unistd.h headers/mtypes.h
readframe.o: headers/dct.h headers/frames.h headers/mheaders.h
readframe.o: headers/bitio.h headers/frame.h headers/prototypes.h
readframe.o: headers/parallel.h headers/param.h headers/readframe.h
readframe.o: headers/fsize.h headers/rgbtoycc.h headers/jpeg.h headers/opts.h
combine.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
combine.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
combine.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
combine.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
combine.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
combine.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
combine.o: headers/ansi.h headers/general.h /usr/include/time.h
combine.o: /usr/include/sys/_time_t.h /usr/include/errno.h
combine.o: /usr/include/sys/errno.h headers/mtypes.h headers/dct.h
combine.o: headers/frames.h headers/mheaders.h headers/bitio.h
combine.o: headers/frame.h headers/search.h headers/mpeg.h
combine.o: headers/prototypes.h headers/parallel.h headers/param.h
combine.o: headers/readframe.h headers/fsize.h headers/combine.h
combine.o: /usr/include/unistd.h /usr/include/sys/unistd.h
jrevdct.o: /usr/include/memory.h /usr/include/string.h
jrevdct.o: /usr/include/sys/_inttypes.h /usr/include/sys/_null.h
jrevdct.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
jrevdct.o: /usr/include/sys/types.h /usr/include/sys/_size_t.h
jrevdct.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
jrevdct.o: /usr/include/math.h /usr/include/limits.h headers/libpnmrw.h
jrevdct.o: /usr/include/malloc.h headers/ansi.h headers/general.h
jrevdct.o: headers/dct.h
frame.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
frame.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
frame.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
frame.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
frame.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
frame.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
frame.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
frame.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
frame.o: headers/fsize.h
fsize.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
fsize.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
fsize.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
fsize.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
fsize.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
fsize.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
fsize.o: headers/ansi.h headers/general.h headers/fsize.h headers/dct.h
frametype.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
frametype.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
frametype.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
frametype.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
frametype.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
frametype.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
frametype.o: headers/ansi.h headers/general.h headers/prototypes.h
frametype.o: headers/frame.h headers/mtypes.h headers/dct.h headers/frames.h
frametype.o: headers/mheaders.h headers/bitio.h headers/param.h
libpnmrw.o: /usr/include/stdio.h /usr/include/sys/stdsyms.h
libpnmrw.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
libpnmrw.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
libpnmrw.o: headers/libpnmrw.h /usr/include/malloc.h /usr/include/string.h
specifics.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
specifics.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
specifics.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
specifics.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
specifics.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
specifics.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
specifics.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
specifics.o: headers/frames.h headers/mheaders.h headers/bitio.h
specifics.o: headers/frame.h headers/fsize.h headers/specifics.h
specifics.o: headers/prototypes.h
rate.o: /usr/include/sys/times.h /usr/include/sys/stdsyms.h
rate.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h headers/all.h
rate.o: /usr/include/stdio.h /usr/include/sys/_null.h
rate.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
rate.o: /usr/include/sys/_wchar_t.h /usr/include/math.h /usr/include/memory.h
rate.o: /usr/include/string.h /usr/include/limits.h headers/libpnmrw.h
rate.o: /usr/include/malloc.h headers/ansi.h headers/general.h
rate.o: headers/mtypes.h headers/dct.h headers/bitio.h headers/frames.h
rate.o: headers/mheaders.h headers/frame.h headers/prototypes.h
rate.o: headers/param.h headers/fsize.h headers/postdct.h headers/mpeg.h
rate.o: headers/parallel.h headers/rate.h
opts.o: /usr/include/stdio.h /usr/include/sys/stdsyms.h
opts.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
opts.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
opts.o: /usr/include/string.h headers/opts.h headers/general.h headers/ansi.h
opts.o: headers/mtypes.h headers/dct.h /usr/include/malloc.h
opts.o: /usr/include/math.h
iframe.o: /usr/include/sys/times.h /usr/include/sys/stdsyms.h
iframe.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
iframe.o: /usr/include/sys/param.h /usr/include/machine/param.h
iframe.o: /usr/include/sys/sysmacros.h /usr/include/machine/param_shm.h
iframe.o: /usr/include/sys/time.h /usr/include/sys/sigevent.h
iframe.o: /usr/include/machine/spl.h /usr/include/sys/kern_svcs.h
iframe.o: headers/all.h /usr/include/stdio.h /usr/include/sys/_null.h
iframe.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
iframe.o: /usr/include/sys/_wchar_t.h /usr/include/math.h
iframe.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
iframe.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
iframe.o: headers/general.h headers/mtypes.h headers/dct.h headers/frames.h
iframe.o: headers/mheaders.h headers/bitio.h headers/frame.h
iframe.o: headers/prototypes.h headers/mpeg.h headers/param.h headers/fsize.h
iframe.o: headers/parallel.h headers/postdct.h headers/rate.h headers/opts.h
pframe.o: /usr/include/assert.h /usr/include/sys/stdsyms.h
pframe.o: /usr/include/sys/param.h /usr/include/sys/types.h
pframe.o: /usr/include/sys/_inttypes.h /usr/include/machine/param.h
pframe.o: /usr/include/sys/sysmacros.h /usr/include/machine/param_shm.h
pframe.o: /usr/include/sys/time.h /usr/include/sys/sigevent.h
pframe.o: /usr/include/machine/spl.h /usr/include/sys/kern_svcs.h
pframe.o: headers/all.h /usr/include/stdio.h /usr/include/sys/_null.h
pframe.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
pframe.o: /usr/include/sys/_wchar_t.h /usr/include/math.h
pframe.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
pframe.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
pframe.o: headers/general.h headers/mtypes.h headers/dct.h headers/bitio.h
pframe.o: headers/frames.h headers/mheaders.h headers/frame.h
pframe.o: headers/prototypes.h headers/param.h headers/fsize.h
pframe.o: headers/postdct.h headers/mpeg.h headers/parallel.h headers/rate.h
pframe.o: headers/opts.h
bframe.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
bframe.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
bframe.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
bframe.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
bframe.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
bframe.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
bframe.o: headers/ansi.h headers/general.h /usr/include/sys/param.h
bframe.o: /usr/include/machine/param.h /usr/include/sys/sysmacros.h
bframe.o: /usr/include/machine/param_shm.h /usr/include/sys/time.h
bframe.o: /usr/include/sys/sigevent.h /usr/include/machine/spl.h
bframe.o: /usr/include/sys/kern_svcs.h /usr/include/assert.h headers/mtypes.h
bframe.o: headers/dct.h headers/bitio.h headers/frames.h headers/mheaders.h
bframe.o: headers/frame.h headers/prototypes.h headers/fsize.h
bframe.o: headers/param.h headers/postdct.h headers/rate.h headers/opts.h
psearch.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
psearch.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
psearch.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
psearch.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
psearch.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
psearch.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
psearch.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
psearch.o: headers/frames.h headers/mheaders.h headers/bitio.h
psearch.o: headers/frame.h headers/search.h headers/prototypes.h
psearch.o: headers/fsize.h headers/param.h
bsearch.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
bsearch.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
bsearch.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
bsearch.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
bsearch.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
bsearch.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
bsearch.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
bsearch.o: headers/frames.h headers/mheaders.h headers/bitio.h
bsearch.o: headers/frame.h headers/search.h headers/fsize.h
block.o: headers/all.h /usr/include/stdio.h /usr/include/sys/stdsyms.h
block.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
block.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h
block.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
block.o: /usr/include/math.h /usr/include/memory.h /usr/include/string.h
block.o: /usr/include/limits.h headers/libpnmrw.h /usr/include/malloc.h
block.o: headers/ansi.h headers/general.h headers/mtypes.h headers/dct.h
block.o: headers/frames.h headers/mheaders.h headers/bitio.h headers/frame.h
block.o: headers/prototypes.h headers/fsize.h headers/opts.h
block.o: headers/postdct.h
parallel.o: /usr/include/sys/types.h /usr/include/sys/stdsyms.h
parallel.o: /usr/include/sys/_inttypes.h /usr/include/sys/socket.h
parallel.o: /usr/include/sys/times.h /usr/include/time.h
parallel.o: /usr/include/sys/_null.h /usr/include/sys/_time_t.h
parallel.o: /usr/include/netinet/in.h /usr/include/unistd.h
parallel.o: /usr/include/sys/unistd.h /usr/include/netdb.h
parallel.o: /usr/include/stdio.h /usr/include/sys/_size_t.h
parallel.o: /usr/include/errno.h /usr/include/sys/errno.h
parallel.o: /usr/include/string.h /usr/include/signal.h
parallel.o: /usr/include/sys/signal.h /usr/include/sys/sigevent.h
parallel.o: /usr/include/sys/siginfo.h /usr/include/sys/newsig.h
parallel.o: headers/all.h /usr/include/stdlib.h /usr/include/sys/_wchar_t.h
parallel.o: /usr/include/math.h /usr/include/memory.h /usr/include/limits.h
parallel.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
parallel.o: headers/general.h headers/param.h headers/mpeg.h headers/mtypes.h
parallel.o: headers/dct.h headers/frame.h headers/prototypes.h
parallel.o: headers/parallel.h headers/bitio.h headers/readframe.h
parallel.o: headers/fsize.h headers/combine.h headers/frames.h
parallel.o: headers/mheaders.h
jpeg.o: /usr/include/stdio.h /usr/include/sys/stdsyms.h
jpeg.o: /usr/include/sys/types.h /usr/include/sys/_inttypes.h
jpeg.o: /usr/include/sys/_null.h /usr/include/sys/_size_t.h headers/all.h
jpeg.o: /usr/include/stdlib.h /usr/include/sys/_wchar_t.h /usr/include/math.h
jpeg.o: /usr/include/memory.h /usr/include/string.h /usr/include/limits.h
jpeg.o: headers/libpnmrw.h /usr/include/malloc.h headers/ansi.h
jpeg.o: headers/general.h headers/mtypes.h headers/dct.h headers/frames.h
jpeg.o: headers/mheaders.h headers/bitio.h headers/frame.h
jpeg.o: headers/prototypes.h headers/param.h headers/readframe.h
jpeg.o: headers/fsize.h headers/rgbtoycc.h headers/jpeg.h jpeg/jpeglib.h
jpeg.o: jpeg/jconfig.h jpeg/jmorecfg.h
main.o: /usr/include/assert.h /usr/include/sys/stdsyms.h headers/all.h
main.o: /usr/include/stdio.h /usr/include/sys/types.h
main.o: /usr/include/sys/_inttypes.h /usr/include/sys/_null.h
main.o: /usr/include/sys/_size_t.h /usr/include/stdlib.h
main.o: /usr/include/sys/_wchar_t.h /usr/include/math.h /usr/include/memory.h
main.o: /usr/include/string.h /usr/include/limits.h headers/libpnmrw.h
main.o: /usr/include/malloc.h headers/ansi.h headers/general.h
main.o: headers/mtypes.h headers/dct.h headers/mpeg.h headers/frame.h
main.o: headers/search.h headers/prototypes.h headers/param.h
main.o: headers/parallel.h headers/bitio.h headers/readframe.h
main.o: headers/combine.h headers/frames.h headers/mheaders.h headers/jpeg.h
main.o: headers/specifics.h headers/opts.h /usr/include/time.h
main.o: /usr/include/sys/_time_t.h
