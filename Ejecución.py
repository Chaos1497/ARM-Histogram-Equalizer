import os
import sys

terminal= "arm-linux-gnueabi-as ~/Desktop/Arqui1/Proyecto1/equalizer.s -o ~/Desktop/Arqui1/Proyecto1/equalizer.o && arm-linux-gnueabi-ld ~/Desktop/Arqui1/Proyecto1/equalizer.o -o ~/Desktop/Arqui1/Proyecto1/equalizer && "
if (len(sys.argv) > 1):
    if (sys.argv[1] == "-d"):
        print("debugOn")
        terminal += "arm-none-eabi-gdb equalizer"
    elif (sys.argv[1] == "-o"):
        print("Dump")
        terminal += "arm-linux-gnueabi-objdump -d equalizer"
else:
    terminal += "qemu-arm ~/Desktop/Arqui1/Proyecto1/equalizer"

x = os.system(terminal)