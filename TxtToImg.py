import matplotlib.image as mpimg
import matplotlib.pyplot as plt
from PIL import Image
import numpy
import cv2

linkImg = "/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/bosque.png"

def create_image():
    urlResult = "/home/esteban/Desktop/Arqui1/Proyecto1/archivoFinal.txt"
    f = open(urlResult, "r")
    matrizNueva = []
    imgColor = mpimg.imread(linkImg)
    vertical = len(imgColor)
    horizontal = len(imgColor[0])
    for i in range(vertical):
        row = []
        for j in range(horizontal):
            valor = f.readline().rstrip("\n")
            valor = ord(valor)
            valor = valor - 20
            row += [valor]
        matrizNueva += [row]
    matrizNumpyNew = numpy.array(matrizNueva, dtype=numpy.uint8)
    img = Image.fromarray(matrizNumpyNew)
    img.save("home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png")
    img.show()

def histog1():
    img1 = cv2.imread(linkImg,0)
    img11 = cv2.equalizeHist(img1)
    histo1 = cv2.calcHist([img11], [0], None, [256], [0,256])
    plt.title("Histograma de imagen original")
    plt.plot(histo1, color="green")
    plt.savefig("/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoOriginal.png")
    return histog2()

def histog2():
    img2 = cv2.imread("home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png", 0)
    img22 = cv2.equalizeHist(img2)
    histo2 = cv2.calcHist([img22], [0], None, [256], [0, 256])
    plt.title("Histograma de imagen ecualizada")
    plt.plot(histo2, color="green")
    plt.savefig("/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoEcualizada.png")

#create_image()
histog1()
