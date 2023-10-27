LESDIR=../../..

include $(LESDIR)/makefiles/StandardHeader.mk

IFILES=project.h

TARGETS=$(INCDIR)/project.h

default:
	@echo "Your options are:  "
	@echo "    make install:    copy all files to include directory"
	@echo "    make clean:      clean directory of unchanged files"

dinstall: $(TARGETS)

debug: $(TARGETS)

install: $(TARGETS)

clean:

all:

$(INCDIR)/project.h: project.h
	@$(INSTALL) $(INCMODE) $(INCDIR) project.h

hinstall: install
