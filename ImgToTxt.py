import numpy as np
from PIL import Image

imagen = Image.open("/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/mujer.png")
image_data = np.asarray(imagen)
pixeles = open("/home/esteban/Desktop/Arqui1/Proyecto1/output.txt", "w")
num_element = 0;

for i in range(len(image_data)):
       for j in range(len(image_data[0])):
           pixeles.write(str(int(image_data[i][j])))
           num_element+=1

pixeles.close()