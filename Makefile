TARGET	:= cro-srp

.PHONY: all

all: Makefile *.k $(TARGET)-compiled.maude

pdf: $(TARGET).pdf

tex: $(TARGET).tex

$(TARGET)-compiled.maude: *.k
	kompile $(TARGET)

$(TARGET).pdf: $(TARGET)*.k
	kompile --pdf $(TARGET)

$(TARGET).tex: $(TARGET)*.k
	kompile --latex $(TARGET)

clean:
	touch *.k
