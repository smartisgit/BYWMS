LESDIR=../..

include $(LESDIR)/makefiles/StandardHeader.mk

TARGETS=$(INCDIR)/usrcolwid.h \
	$(INCDIR)/usrddl.h \
	$(INCDIR)/usrerr.h \
	$(INCDIR)/usrgendef.h \
	$(INCDIR)/usrtbldef.h \
	$(INCDIR)/varcolwid.h \
	$(INCDIR)/varddl.h \
	$(INCDIR)/varerr.h \
	$(INCDIR)/vargendef.h \
	$(INCDIR)/vartbldef.h

default:
	@echo "Your options are:  "
	@echo "    make install:    copy all files to include directory"
	@echo "    make clean:      clean directory of unchanged files"

dinstall: $(TARGETS)

debug: $(TARGETS)

install: $(TARGETS)

clean:

all:

$(INCDIR)/usrcolwid.h: usrcolwid.h
	@$(INSTALL) $(INCMODE) $(INCDIR) usrcolwid.h

$(INCDIR)/usrddl.h: usrddl.h
	@$(INSTALL) $(INCMODE) $(INCDIR) usrddl.h

$(INCDIR)/usrerr.h: usrerr.h
	@$(INSTALL) $(INCMODE) $(INCDIR) usrerr.h

$(INCDIR)/usrgendef.h: usrgendef.h
	@$(INSTALL) $(INCMODE) $(INCDIR) usrgendef.h

$(INCDIR)/usrtbldef.h: usrtbldef.h
	@$(INSTALL) $(INCMODE) $(INCDIR) usrtbldef.h

$(INCDIR)/varcolwid.h: varcolwid.h
	@$(INSTALL) $(INCMODE) $(INCDIR) varcolwid.h

$(INCDIR)/varddl.h: varddl.h
	@$(INSTALL) $(INCMODE) $(INCDIR) varddl.h

$(INCDIR)/varerr.h: varerr.h
	@$(INSTALL) $(INCMODE) $(INCDIR) varerr.h

$(INCDIR)/vargendef.h: vargendef.h
	@$(INSTALL) $(INCMODE) $(INCDIR) vargendef.h

$(INCDIR)/vartbldef.h: vartbldef.h
	@$(INSTALL) $(INCMODE) $(INCDIR) vartbldef.h

hinstall: install
