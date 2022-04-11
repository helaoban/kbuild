all: conf nconf

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

# Kconfig
# ---------------------------------------------------------------------------

common-objs	:= confdata.o expr.o lexer.lex.o menu.o parser.tab.o \
		   preprocess.o symbol.o util.o

$(obj)/lexer.lex.o: $(obj)/parser.tab.h
CFLAGS_lexer.lex.o	:= -I $(srctree)/$(src)
CFLAGS_parser.tab.o	:= -I $(srctree)/$(src)

conf: conf.o $(common-objs)
	$(CC) -o $@ $^ -lncursesw -lmenuw -lpanelw

# nconf: Used for the nconfig target based on ncurses
nconf: nconf.o nconf.gui.o $(common-objs)
	$(CC) -o $@ $^ -lncursesw -lmenuw -lpanelw
