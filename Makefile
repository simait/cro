TARGET	:= cro-extended

all: Makefile $(TARGET)-compiled.maude

pdf: $(TARGET).pdf

$(TARGET)-compiled.maude: $(TARGET)*.k
	kompile $(TARGET)

$(TARGET).pdf: $(TARGET)*.k
	kompile --pdf $(TARGET)

clean:
	touch *.k
