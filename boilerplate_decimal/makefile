.PHONY = all clean

CC = nasm                       # compiler to use

LINKERFLAG = -melf_i386

SRCS := $(wildcard *.asm)
BINS := $(SRCS:%.asm=%)

all: ${BINS}

%: %.o
	@echo "Checking.."
	ld ${LINKERFLAG} $< -o $@

%.o: %.asm
	@echo "Creating object.."
	${CC} -f elf $<

clean: 
	rm -rvf *.o ${BINS}

