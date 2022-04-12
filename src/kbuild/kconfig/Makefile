# SPDX-License-Identifier: GPL-2.0
# ===========================================================================
# Kernel configuration targets
# These targets are used from top-level makefile

ifdef KBUILD_KCONFIG
Kconfig := $(KBUILD_KCONFIG)
else
Kconfig := Kconfig
endif

ifndef KBUILD_DEFCONFIG
KBUILD_DEFCONFIG := defconfig
endif

ifeq ($(quiet),silent_)
silent := -s
endif

export KCONFIG_DEFCONFIG_LIST :=
KCONFIG_DEFCONFIG_LIST += $(KBUILD_DECONFIG)

# We need this, in case the user has it in its environment
unexport CONFIG_

config-prog	:= kb-conf
nconfig-prog	:= kb-nconf

define config_rule
PHONY += $(1)
$(1):
	$(Q)$($(1)-prog) $(silent) $(Kconfig)
endef

$(foreach c, config nconfig, $(eval $(call config_rule,$(c))))

# These targets map 1:1 to the commandline options of 'conf'
#
# Note:
#  syncconfig has become an internal implementation detail and is now
#  deprecated for external use
simple-targets := oldconfig allnoconfig allyesconfig \
	alldefconfig listnewconfig olddefconfig syncconfig \
	helpnewconfig

PHONY += $(simple-targets)

$(simple-targets):
	$(Q)kb-conf $(silent) --$@ $(Kconfig)

PHONY += savedefconfig defconfig

savedefconfig:
	$(Q)kb-conf $(silent) --$@=defconfig $(Kconfig)

defconfig:
	@$(kecho) "*** Default configuration is based on target '$(KBUILD_DEFCONFIG)'"
	$(Q)$(MAKE) -f $(srctree)/Makefile $(KBUILD_DEFCONFIG)

%_defconfig:
	$(Q)kb-conf $(silent) --defconfig=arch/$(SRCARCH)/configs/$@ $(Kconfig)

configfiles=$(wildcard $(srctree)/kernel/configs/$@ $(srctree)/arch/$(SRCARCH)/configs/$@)

%.config:
	$(if $(call configfiles),, $(error No configuration exists for this target on this architecture))
	$(Q)$(KBUILD_CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m .config $(configfiles)
	$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig

# Help text used by make help
help:
	@echo  '  config	  - Update current config utilising a line-oriented program'
	@echo  '  nconfig         - Update current config utilising a ncurses menu based program'
	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
	@echo  '  defconfig	  - New config with default from ARCH supplied defconfig'
	@echo  '  savedefconfig   - Save current config as ./defconfig (minimal config)'
	@echo  '  allnoconfig	  - New config where all options are answered with no'
	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
	@echo  '  alldefconfig    - New config with all symbols set to default'
	@echo  '  listnewconfig   - List new options'
	@echo  '  helpnewconfig   - List new options and help text'
	@echo  '  olddefconfig	  - Same as oldconfig but sets new symbols to their'
	@echo  '                    default value without prompting'
	@echo  '  testconfig	  - Run Kconfig unit tests (requires python3 and pytest)'