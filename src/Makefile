all: kconfig

# progs-y	:= fixdep
# always	:= $(progs-y)

# # fixdep is needed to compile other host programs
# $(addprefix $(obj)/,$(filter-out fixdep,$(always))): $(obj)/fixdep

kconfig:
	cd kconfig && $(MAKE)

.PHONY: kconfig
