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
	install -D src/fixdep $(PREFIX)/bin/fixdep
	install -D src/kconfig/kb-conf $(PREFIX)/bin/kb-conf
	install -D src/kconfig/kb-nconf $(PREFIX)/bin/kb-nconf
	install -D src/kconfig/merge-config.sh $(PREFIX)/bin/kb-merge-config
	install -D src/kbuild.sh $(PREFIX)/bin/kbuild
	install -D src/kbuild.scm $(PREFIX)/bin/kbuild.scm
	for file in $$(find src/kbuild -type f); do \
		install -D "$$file" $(PREFIX)/lib/$${file##src/kbuild/}; \
	done

.PHONY: install


devconf:
	mkdir --parents build
	./configure --prefix="$(srctree)/build"

.PHONY: devconf
