#CFLAGS=-W -Wall -O3 -s -D_FILE_OFFSET_BITS=64 -mtune=i686 -march=i386 -I/home/tuitfun/include -L/home/tuitfun/lib

# The DESTDIR is macro is used for staged builds, so that it gets installed
# under a fake root directory for the sake of packaging. Unlike PREFIX, it will
# not actually be run from this directory.
#DESTDIR - reserved for rpmbuild

# According to a convention, PREFIX macro is the prefix of instalation.
PREFIX = /usr/local

ENABLE_AVIF=1
ENABLE_WEBP=1
ENABLE_LOCALE=0

KERNELNAME=$(shell uname -s)
OSNAME=$(shell uname -o)
CFLAGS=-W -Wall -Wextra -Wshadow -Wunreachable-code -Wcast-align -Wuninitialized $(USER_CFLAGS)
OUT=../bin
LIBSDIR=../lib
LOCALEDIR=\"/usr/share/locale\"

ifeq ($(KERNELNAME),FreeBSD)
LIBS+=-L/usr/local/lib
INCPATH+=-I/usr/local/include
endif

ifeq ($(OSNAME),Darwin)
INCPATH=$(shell pkg-config --cflags-only-I gdlib libavutil)
LIBS+=$(shell pkg-config --libs-only-L gdlib libavutil)
endif

ifeq ($(KERNELNAME),Linux)
INCPATH=-I/usr/include/ffmpeg
LIBS+=$(shell pkg-config --libs-only-L libavutil)
endif

ifeq ($(OSNAME),Msys)
LIBS=-L/mingw64/lib
INCPATH=-I/mingw64/include
CFLAGS=-W
endif

ifeq ($(ENABLE_WEBP),1)
    CFLAGS+=-DMTN_WITH_WEBP
endif

ifeq ($(ENABLE_AVIF),1)
    CFLAGS+=-DMTN_WITH_AVIF
endif

ifeq ($(ENABLE_LOCALE),1)
    CFLAGS+=-DMTN_WITH_LOCALE -DLOCALEDIR=$(LOCALEDIR)
endif

LIBS+=-lavcodec -lavformat -lavcodec -lswscale -lavutil -lavfilter -lgd -lm
S_INCPATH=-I$(LIBSDIR)/FFmpeg -I$(LIBSDIR)/libgd/src
S_LIBS= -static-libgcc -static \
	$(LIBSDIR)/FFmpeg/libswscale/libswscale.a \
	$(LIBSDIR)/FFmpeg/libavcodec/libavcodec.a \
	$(LIBSDIR)/FFmpeg/libswresample/libswresample.a \
	$(LIBSDIR)/FFmpeg/libavformat/libavformat.a \
	$(LIBSDIR)/FFmpeg/libavfilter/libavfilter.a \
	$(LIBSDIR)/FFmpeg/libavutil/libavutil.a \
	$(LIBSDIR)/FFmpeg/libavcodec/libavcodec.a \
	$(LIBSDIR)/libgd/Bin/libgd.a \
	$(S_LIBS_EXTRA) \
    -lpthread -lbz2 -lfontconfig -lfreetype -lbrotlidec -lbrotlicommon -lexpat -ljpeg -lpng16 -lwebp -lz -lzimg -lm -lstdc++

build: $(OUT)/mtn

$(OUT)/mtn: mtn.c $(OUT)
	$(CC) -o $@ mtn.c $(INCPATH) $(CFLAGS) -O3 $(LIBS)

$(OUT):
	mkdir -p $@

static: mtn.c $(OUT)
	$(CC) -o $(OUT)/mtn mtn.c $(S_INCPATH) $(CFLAGS) $(S_LIBS) -DMTN_STATIC

debug: mtn.c $(OUT)
	$(CC) -o $(OUT)/mtn mtn.c $(INCPATH) $(CFLAGS) -g -DDEBUG $(LIBS)

valgrind: debug
	valgrind --leak-check=full $(OUT)/mtn

analyze: CFLAGS+=-fanalyzer
analyze: clean debug

clean:
	rm -f $(OUT)/mtn

distclean:
	rm -rf $(OUT)

rebuild:  clean build
rebuild_static: clean static

../po/mtn.pot: mtn.c
	xgettext -d mtn -k__ -o $@ mtn.c

locale: ../po/mtn.pot
	msgmerge --update --no-fuzzy-matching --backup=none --lang=$(LANG) ../po/$(LANG).po ../po/mtn.pot

test_bin:
	$(OUT)/mtn -f ../test/font.ttf -h 50 -O /tmp $(MOVIEFILE)
	test -s /tmp/sample_s.jpg

static_test: static test_bin

tests: CFLAGS+=-DTESTS
tests: run
	
run: build
	$(OUT)/mtn --version

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	install -m 755 $(OUT)/mtn $(DESTDIR)$(PREFIX)/bin/
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/mtn
	cp -Rp ../doc/* $(DESTDIR)$(PREFIX)/share/doc/mtn
	cp -p ../LICENSE $(DESTDIR)$(PREFIX)/share/doc/mtn
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	cp -p ../man/mtn.1 $(DESTDIR)$(PREFIX)/share/man/man1/

uninstall:
	rm -f  $(DESTDIR)$(PREFIX)/share/man/man1/mtn.1
	rm -f  $(DESTDIR)$(PREFIX)/bin/mtn
	rm -rf $(DESTDIR)$(PREFIX)/share/doc/mtn
