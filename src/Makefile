all: fixdep kconfig kbuild.sh

# progs-y	:= fixdep
# always	:= $(progs-y)

# # fixdep is needed to compile other host programs
# $(addprefix $(obj)/,$(filter-out fixdep,$(always))): $(obj)/fixdep

fixdep: fixdep.o
	$(CC) -o $@ $<

kbuild.sh: kbuild.m4
	m4 --define=M4_PREFIX=$(PREFIX) $< > $@
	chmod +x $@

kconfig:
	cd kconfig && $(MAKE)

.PHONY: kconfig

clean:
	rm -f kbuild.sh
	rm -f fixdep
