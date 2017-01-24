DIRS=salpa/private ephys findx statx peakx gmapimg/private

ALL:

define DIRTEMPLATE
ALL: DIR$1
.PHONY: DIR$1
DIR$1:; make -C $1
endef

$(foreach d,$(DIRS), $(eval $(call DIRTEMPLATE,$d)))
