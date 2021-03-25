from PIL import Image

# Get bytes from image
def getPx_Image(imageLink):

    im = Image.open(imageLink).convert('L')
    pix_val = list(im.getdata())
    return pix_val


def imagePx_To_File(linkImage):
    byteImage = getPx_Image(linkImage)
    posBytes = 0
    file = open("output.txt", "w")
    file.close()
    for i in range(0, 16):
        filename = "C:/Users/Esteban/Desktop/Esteban/TEC/Carrera CE/Arquitectura de Computadores 1/Proyecto 1/Muestra/part%d.txt" % (i)
        writeFile = open(filename, 'w')
        # output.txt es para comprobar los bytes con el script fileToImage.py
        filename = "output.txt"
        outputFile = open(filename, 'a')
        for j in range(0, 10000):
            if (posBytes >= len(byteImage)):
                writeFile.write("%s\n" % "108")
                break

            else:
                valHex = hex(byteImage[posBytes])[2:]
                outputFile.write("%s" % valHex.upper())
                outputFile.write(" ")
                if (len(valHex) == 1):
                    valHex = "00" + valHex
                if (len(valHex) == 2):
                    valHex = "0" + valHex
                writeFile.write("%s\n" % valHex.upper())
            posBytes += 1
        outputFile.close()
        writeFile.close()
    return


imagePx_To_File("C:/Users/Esteban/Desktop/Esteban/TEC/Carrera CE/Arquitectura de Computadores 1/Proyecto 1/Muestra/muestra.jpg")
