.PHONY = all clean

CC = nasm                       # compiler to use

LINKERFLAG = -m32

SRCS := $(wildcard *.asm)
BINS := $(SRCS:%.asm=%)

all: ${BINS}

%: %.o
	@echo "Checking.."
	gcc ${LINKERFLAG} $< -o $@

%.o: %.asm
	@echo "Creating object.."
	${CC} -f elf $<

clean: 
	rm -rvf *.o ${BINS}

