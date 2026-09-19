CROSS_COMPILE ?= arm-linux-gnueabihf-

all: startup.s
	$(CROSS_COMPILE)as startup.s -o startup.o
	$(CROSS_COMPILE)objcopy startup.o startup.bin -O binary
	$(CROSS_COMPILE)objdump -D -b binary -marm startup.bin > startup.lst
	cp *.bin /$(HOME)/srv/tftp


clean:
	rm *.o *.bin *.lst

