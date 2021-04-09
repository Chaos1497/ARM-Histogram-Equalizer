import numpy as np
from PIL import Image

imagen = Image.open("/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/bosque.png")
image_data = np.asarray(imagen)
pixeles = open("/home/esteban/Desktop/Arqui1/Proyecto1/pixPrecargados.txt", "w")
for i in range(len(image_data)):
       for j in range(len(image_data[0])):
           pixel = str(int(image_data[i][j]))
           if (len(pixel) == 1):
               pixel = "00" + pixel #Si el pixel es de 1 digito, le pongo dos 0's a la izquierda
           elif (len(pixel) == 2):
               pixel = "0" + pixel #Si el pixel es de 2 digitos, le pongo un 0 a la izquierda
           pixeles.write(pixel)
pixeles.close()