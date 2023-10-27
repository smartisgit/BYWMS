all: install

install: FRC
	cd ./src; $(MAKE) install

clean:
	cd ./src; $(MAKE) clean

nodebug:
	$(MAKE) DEBUG=-O install

superclean: clean
	@rm -f bin/*
	@rm -f include/*
	@rm -f lib/*

rebuild: clean install

FRC:
