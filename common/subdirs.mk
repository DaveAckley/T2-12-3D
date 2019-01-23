TOPTARGETS := all build clean realclean
ALLDEPS += subdirs.mk

ifndef SUBDIRS
SUBDIRS := $(filter-out $(EXCLUDE_SUBDIRS),$(patsubst %/.,%,$(wildcard */.)))
endif

$(TOPTARGETS): $(SUBDIRS)

clean:
	@rm -f *~ .*~

realclean:	clean

$(SUBDIRS):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)
