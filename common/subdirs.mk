TOPTARGETS := all build clean realclean
ALLDEPS += subdirs.mk

ifndef SUBDIRS
SUBDIRS := $(filter-out $(EXCLUDE_SUBDIRS),$(patsubst %/.,%,$(wildcard */.)))
endif

$(TOPTARGETS): $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

clean:
	@rm -f *~

.PHONY: $(TOPTARGETS) $(SUBDIRS)
