import cv2
import numpy


def get_bytes_from_file(filename):
    with open(filename, "r") as f:
        return f.read()


def create_image(finname, foutname, width, height):
    # Acomoda el array de la imagen
    data = get_bytes_from_file(finname).rstrip('\x00').rstrip().lstrip()
    data = data.split(' ')
    temp = []
    for m in data:
        if(m != ''):
            temp.append(m)
    data = temp
    data = list(map(lambda x:int(x,16),data))
    while(len(data)<307200):
        data.append(0)

    data = numpy.array(data)
    # Escribe la imagen
    uwuImage = data.reshape(width, height)
    cv2.imwrite(foutname, uwuImage)


create_image("C:/Users/Esteban/Desktop/Esteban/TEC/Carrera CE/Arquitectura de Computadores 1/Proyecto 1/Resultado/finalFileImage.txt", "C:/Users/Esteban/Desktop/Esteban/TEC/Carrera CE/Arquitectura de Computadores 1/Proyecto 1/Resultado/ecualizada.png", 640, 480)