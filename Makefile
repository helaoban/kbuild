CC       = gcc
LEX 	 = flex
YACC     = bison

CFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer

this-makefile	:= $(lastword $(MAKEFILE_LIST))
srctree	        := $(realpath $(dir $(this-makefile)))

# Read in config
include .config

export

all: src

.config:
	@echo >&2 "No config file, you need to run ./config."
	@/bin/false

# LEX
# ---------------------------------------------------------------------------

%.lex.c: %.l
	$(LEX) -o$@ -L $<

# YACC
# ---------------------------------------------------------------------------
%.tab.c %.tab.h: %.y
	$(YACC) -o $(basename $@).c --defines=$(basename $@).h -t -l $<


# C
# ---------------------------------------------------------------------------
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

src: .config
	cd $@ && $(MAKE)

.PHONY: src

test: .config
	@echo "PREFIX: " $(PREFIX)

env:
	guix shell --manifest=manifest.scm

.PHONY: env


distclean:
	rm -rf .config

.PHONY: distclean


install: src
	install -D src/kbuild.sh $(PREFIX)/bin/kbuild
	install -D src/kbuild.scm $(PREFIX)/bin/kbuild.scm
	for file in src/kbuild/*; do install -D "$$file" $(PREFIX)/lib/$$(basename "$$file"); done

.PHONY: install


devconf:
	mkdir --parents build
	./config --prefix="$(srctree)/build"

.PHONY: devconf
