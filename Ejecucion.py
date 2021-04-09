import os
import sys

terminal= "arm-linux-gnueabi-as /home/esteban/Desktop/Arqui1/Proyecto1/equalizer.s -o /home/esteban/Desktop/Arqui1/Proyecto1/equalizer.o && arm-linux-gnueabi-ld /home/esteban/Desktop/Arqui1/Proyecto1/equalizer.o -o /home/esteban/Desktop/Arqui1/Proyecto1/equalizer && qemu-arm /home/esteban/Desktop/Arqui1/Proyecto1/equalizer"

x = os.system(terminal)