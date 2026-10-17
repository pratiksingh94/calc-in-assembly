AS = nasm
ASFLAGS = -f elf64
LD = ld

all: main

main: main.o
	$(LD) main.o -o calc-in-asm

main.o: main.asm
	$(AS) $(ASFLAGS) main.asm -o main.o

clean:
	rm -f calc-in-asm *.o

.PHONY: all clean