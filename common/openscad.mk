SRCFILES:=$(wildcard *.scad)
BINDIR:=$(ROOTDIR)/output/stl
FINAL_STL_FILES:=$(patsubst %.scad,$(BINDIR)/%.stl,$(SRCFILES))
DRAFT_STL_FILES:=$(patsubst %.scad,$(BINDIR)/%-DRAFT.stl,$(SRCFILES))
ifdef STL_FINAL
  STLFILES:=$(FINAL_STL_FILES)
else
  STLFILES:=$(DRAFT_STL_FILES)
endif
ALLDEPS+=Makefile $(ROOTDIR)/common/openscad.mk

$(BINDIR)/%.stl:	%.scad $(ALLDEPS)
	openscad -o $@ $< 

$(BINDIR)/%-DRAFT.stl:	%.scad $(ALLDEPS)
	openscad -o $@ $< 

build:	$(STLFILES)

view:	$(STLFILES)
	meshlab $<

clean:	FORCE
	@rm -f *~

realclean:	clean
	@rm -f $(FINAL_STL_FILES) $(DRAFT_STL_FILES)

.PHONY:	FORCE
