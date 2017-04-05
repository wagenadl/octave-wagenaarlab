######################################################################
# Makefile for Wagenaar lab octave code

######################################################################
# Compiling
ALL:

define DIRTEMPLATE
ALL: DIR$1
.PHONY: DIR$1
DIR$1:; +make -C $1
endef

MAKEFILES=$(wildcard */Makefile) $(wildcard */private/Makefile)
MAKEDIRS=$(subst /Makefile,,$(MAKEFILES))
ALLDIRS=$(filter-out matlab/,$(filter-out debian/,$(wildcard */))) \
	$(sort $(dir $(wildcard octave/*/*))) \
	zmxtracer/glass zmxtracer/lenses
PRIVATEDIRS=$(wildcard */private)

$(foreach d,$(MAKEDIRS), $(eval $(call DIRTEMPLATE,$d)))

######################################################################
# Archiving

TAR:;	git archive --prefix=octave-wagenaarlab/ \
		-o ../../octave-wagenaarlab$(VERSIONSUFFIX).tar.gz \
		HEAD .

######################################################################
# Installation

install:	ALL INSTALLFILES

ifdef DESTDIR
  # Debian uses this
  INSTALLPATH = $(DESTDIR)/usr
else
  INSTALLPATH = /usr/local
endif

OCT_PACKAGE=wagenaarlab-$(lastword $(shell grep Version DESCRIPTION))
# The version number for the octave package is obtained from the DESCRIPTION file

DEB_HOST_MULTIARCH = $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
OCT_HOST_TYPE = $(shell octave-config -p CANONICAL_HOST_TYPE)
OCT_API_VSN = $(shell octave-config -p API_VERSION)
OCTBINDEST=$(INSTALLPATH)/lib/$(DEB_HOST_MULTIARCH)/octave/packages/$(OCT_PACKAGE)/$(OCT_HOST_TYPE)-$(OCT_API_VSN)
OCTMDEST=$(INSTALLPATH)/share/octave/packages/$(OCT_PACKAGE)

define INSTALLTEMPLATE =
INSTALLFILES: INSTALLM-$(1)

INSTALLM-$(1):;
	install -d $$(OCTMDEST)/$(1)
	install -m0644 $$(wildcard $(1)/*.m) $$(OCTMDEST)/$(1)
ifeq ($$(wildcard $(1)/*.oct),)
else
INSTALLFILES: INSTALLOCT-$(1)
INSTALLOCT-$(1):
	install -d $$(subst /private,,$$(OCTBINDEST)/$(1))
	install -m0644 $$(wildcard $(1)/*.oct) \
		$$(subst /private,,$$(OCTBINDEST)/$(1))
	strip $$(subst /private,,$$(OCTBINDEST)/$(1))/*.oct
endif
ifeq ($$(wildcard $(1)/*.mex),)
else
INSTALLFILES: INSTALLMEX-$(1)
INSTALLMEX-$(1):
	install -d $$(subst /private,,$$(OCTBINDEST)/$(1))
	install -m0644 $$(wildcard $(1)/*.mex) \
		$$(subst /private,,$$(OCTBINDEST)/$(1))
	strip $$(subst /private,,$$(OCTBINDEST)/$(1))/*.mex
endif
endef

$(foreach d,$(ALLDIRS), $(eval $(call INSTALLTEMPLATE,$d)))
$(foreach d,$(PRIVATEDIRS), $(eval $(call INSTALLTEMPLATE,$d)))

INSTALLFILES: PACKINFO

PACKINFO:;
	install -d $(OCTMDEST)/packinfo
	install -m644 DESCRIPTION COPYING NEWS README $(OCTMDEST)/packinfo
	install -m644 PKG_ADD PKG_DEL $(OCTMDEST)

######################################################################
# Documentation
INSTALLFILES: DOCS

DOCPATH=$(INSTALLPATH)/share/doc/octave-wagenaarlab
DOCS:;
	install -d $(DOCPATH)/zmx
	install zmxtracer/doc/*.pdf $(DOCPATH)/zmx/

######################################################################
# Zip
zip:; git archive -o /tmp/octave-wagenaarlab-`git describe`.zip --prefix wagenaarlab/ HEAD .
	echo "Created archive in /tmp/octave-wagenaarlab-`git describe`.zip"
