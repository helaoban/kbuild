all: kb-conf kb-nconf

# Kconfig
# ---------------------------------------------------------------------------

common-objs	:= confdata.o expr.o lexer.lex.o menu.o parser.tab.o \
		   preprocess.o symbol.o util.o

$(obj)/lexer.lex.o: $(obj)/parser.tab.h
CFLAGS_lexer.lex.o	:= -I $(srctree)/$(src)
CFLAGS_parser.tab.o	:= -I $(srctree)/$(src)

kb-conf: conf.o $(common-objs)
	$(CC) -o $@ $^ -lncursesw -lmenuw -lpanelw

# nconf: Used for the nconfig target based on ncurses
kb-nconf: nconf.o nconf.gui.o $(common-objs)
	$(CC) -o $@ $^ -lncursesw -lmenuw -lpanelw
