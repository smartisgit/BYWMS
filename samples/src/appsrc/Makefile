SUBDIR=hello

all: ${SUBDIR}

${SUBDIR}: FRC
	cd ./$@; $(MAKE) $(TARGET)

clean: 
	$(MAKE) TARGET=clean

install:
	$(MAKE) TARGET=install

FRC:
