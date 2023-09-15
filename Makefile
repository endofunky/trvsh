TARGET ?= trvsh
NASM ?= nasm

all: $(TARGET)
.PHONY: all

$(TARGET): $(TARGET).asm
	$(NASM) -f bin -o $(TARGET) $<
	chmod a+x $(TARGET)

run: $(TARGET)
	$(PWD)/$(TARGET)
.PHONY: run

clean:
	rm -f $(TARGET)
.PHONY: clean
