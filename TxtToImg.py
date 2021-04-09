import matplotlib.image as mpimg
import matplotlib.pyplot as plt
from PIL import Image
import numpy
import cv2

linkImg = "/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/bosque.png"
linkRemapeo = "/home/esteban/Desktop/Arqui1/Proyecto1/archivoRemapeo.txt"
linkFinal = "/home/esteban/Desktop/Arqui1/Proyecto1/archivoFinal.txt"

def reconstruir():
    txt1 = open(linkRemapeo, "r")
    txt2 = open(linkFinal, "w+")
    pixel = 0
    for elemento in txt1:
        valor = elemento.rstrip("\n")
        valor0 = int(valor[0]) << 22
        pixel += valor0
        valor1 = int(valor[1]) << 20
        pixel += valor1
        valor2 = int(valor[2]) << 18
        pixel += valor2
        valor3 = int(valor[3]) << 16
        pixel += valor3
        valor4 = int(valor[4]) << 14
        pixel += valor4
        valor5 = int(valor[5]) << 12
        pixel += valor5
        valor6 = int(valor[6]) << 10
        pixel += valor6
        valor7 = int(valor[7]) << 8
        pixel += valor7
        valor8 = int(valor[8]) << 6
        pixel += valor8
        valor9 = int(valor[9]) << 4
        pixel += valor9
        valor10 = int(valor[10]) << 2
        pixel += valor10
        valor11 = int(valor[11])
        pixel += valor11
        txt2.write(str(pixel) + "\n")
        pixel = 0
    txt2.close()
    create_image()


def create_image():
    f = open(linkFinal, "r")
    matrizNueva = []
    imgColor = mpimg.imread(linkImg)
    vertical = len(imgColor)
    horizontal = len(imgColor[0])
    for i in range(vertical):
        row = []
        for j in range(horizontal):
            valor = f.readline().rstrip("\n")
            valor = int(valor)
            row += [valor]
        matrizNueva += [row]
    matrizNumpyNew = numpy.array(matrizNueva, dtype=numpy.uint8)
    img = Image.fromarray(matrizNumpyNew)
    img.save("/home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png")
    histogramas()



def histogramas():
    img1 = cv2.imread(linkImg,0)
    img11 = cv2.equalizeHist(img1)
    histo1 = cv2.calcHist([img11], [0], None, [256], [0,256])
    plt.title("Histograma de imagen original")
    plt.plot(histo1, color="green")
    plt.savefig("/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoOriginal.png")

    img2 = cv2.imread("/home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png", 0)
    img22 = cv2.equalizeHist(img2)
    histo2 = cv2.calcHist([img22], [0], None, [256], [0, 256])
    plt.title("Histograma de imagen ecualizada")
    plt.plot(histo2, color="green")
    plt.savefig("/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoEcualizada.png")


reconstruir()
