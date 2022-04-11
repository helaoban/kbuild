CC       = gcc
LEX 	 = flex
YACC     = bison

CFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer

export CC CFLAGS LEX YACC

all: src

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

src:
	cd $@ && $(MAKE)

.PHONY: src

env:
	guix shell --manifest=manifest.scm

.PHONY: env
