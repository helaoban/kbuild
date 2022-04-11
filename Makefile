CC       = gcc
LEX 	 = flex
YACC     = bison

CFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer

export CC CFLAGS LEX YACC


all: src

src:
	cd $@ && $(MAKE)

.PHONY: src

env:
	guix shell --manifest=manifest.scm

.PHONY: env
