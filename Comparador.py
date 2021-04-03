from tkinter import *
from tkinter import messagebox

global imagen1
global imagen2
global imagen3
global imagen4

def abrir():
    global file_name
    global file_name2
    global file_name3
    global file_name4

    file_name = "/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/atardecer.png"
    imag=PhotoImage(file=file_name)
    imagen1.itemconfigure("firstpic",image=imag)
    imagen1.img=imag

    file_name2 = "/home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png"
    imag2=PhotoImage(file=file_name2)
    imagen2.itemconfigure("secondpic",image=imag2)
    imagen2.img=imag2

    file_name3 = "/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoOriginal.png"
    imag3 = PhotoImage(file=file_name3)
    imagen3.itemconfigure("thirdpic", image=imag3)
    imagen3.img = imag3

    file_name4 = "/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoEcualizada.png"
    imag4 = PhotoImage(file=file_name4)
    imagen4.itemconfigure("fourthpic", image=imag4)
    imagen4.img = imag4

def mostrar():
    return messagebox.showinfo("Completado","Se han cargado los resultados"), abrir()
#############################################################################################################

#Inicio de interfaz grafica, definicion y caraxteristicas de la ventana
ventana = Tk()
ventana.title("Proyecto 1 para Arquitectura de Computadores 1 de Esteban Andres Zúñiga Orozco")
ventana.geometry("1200x750")
ventana.resizable(width=False, height=False)
ventana.configure(bg="#FA5734")
colorLetra = "#000000"
etiquetaTitulo = Label(ventana, text="Ecualizador de histogramas", bg="#FA5734", fg=colorLetra, font="Helvetica, 20").place(x=400, y=10)
etiquetaImgOriginal = Label(ventana, text="Imagen original:", bg="#FA5734", fg=colorLetra, font="Helvetica, 12").place(x=10, y=200)
etiquetaImgEcualizada = Label(ventana, text="Imagen ecualizada:", bg="#FA5734", fg=colorLetra, font="Helvetica, 12").place(x=10, y=550)
etiquetaHistOriginal = Label(ventana, text="Histograma original:", bg="#FA5734", fg=colorLetra, font="Helvetica, 12").place(x=650, y=200)
etiquetaHistEcualizada = Label(ventana, text="Histograma ecualizado:", bg="#FA5734", fg=colorLetra, font="Helvetica, 12").place(x=650, y=550)
boton1 = Button(ventana, text="Mostrar resultados", command=mostrar, bg="#FFD700", fg=colorLetra, font="20").place(x=530, y=650)
# Imagen en canvas al abrir
imagen1 = Canvas(ventana, width=300, height=300, bg="#FFD600")
imagen1.place(x=190, y=50)
imagen1.create_image(175, 175, image='', tag="firstpic")
# Imagen filtrada en canvas
imagen2 = Canvas(ventana, width=300, height=300, bg="#FFD600")
imagen2.place(x=190, y=400)
imagen2.create_image(175, 175, image='', tag="secondpic")
# Histograma de imagen original
imagen3 = Canvas(ventana, width=300, height=300, bg="#FFD600")
imagen3.place(x=850, y=50)
imagen3.create_image(175, 175, image='', tag="thirdpic")
# Histograma de imagen ecualizada
imagen4 = Canvas(ventana, width=300, height=300, bg="#FFD600")
imagen4.place(x=850, y=400)
imagen4.create_image(175, 175, image='', tag="fourthpic")
ventana.mainloop()
