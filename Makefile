AS = nasm
ASFLAGS = -f elf64
LD = ld

all: main

main: main.o
	$(LD) main.o -o main

main.o: main.asm
	$(AS) $(ASFLAGS) main.asm -o main.o

clean:
	rm -f main *.o

.PHONY: all clean