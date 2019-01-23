SRCFILES:=$(wildcard *.scad)
BINDIR:=$(ROOTDIR)/output/stl
STLFILES:=$(patsubst %.scad,$(BINDIR)/%.stl,$(SRCFILES))
ALLDEPS+=Makefile $(ROOTDIR)/common/openscad.mk

$(BINDIR)/%.stl:	%.scad $(ALLDEPS)
	openscad -o $@ $< 

build:	$(STLFILES)

view:	$(STLFILES)
	meshlab $<

clean:	FORCE
	@rm -f @~

realclean:	clean
	rm -f $(STLFILES)

.PHONY:	FORCE
