# ARM-Histogram-Equalizer

Ecualizador de histogramas basado en lenguaje ensamblador ARM

Herramientas utilizadas:

	PyCharm con Python 3.8
		Matplotlib
		PIL
		Open CV
		Tkinter
	ARM Cross Toolchain
	ARM GDB Debugger
	Qemu

Instrucciones de uso:

	Siga los pasos en el siguiente orden:
		1. Dentro de PyCharm ejecute el archivo ImgToTxt.py 
			(Para obtener los pixeles de la imagen deseada)
			
		2. Abra una terminal dentro de la carpeta Proyecto1 y escriba los comandos a continuación en el siguiente orden: 
			arm-linux-gnueabi-as equalizer.s -o equalizer.o
			arm-linux-gnueabi-ld equalizer.o -o equalizer
			./equalizer
			
			Si el comando ./equalizer le da error, ejecute el siguiente comando, de no ser así omítalo
			qemu-arm equalizer

		3. Dentro de PyCharm ejecute el archivo TxtToImg.py 
			(Para reconstruir el resultado del ensamblador ejecutado en el paso 2 y crear los histogramas)
			
		4. Dentro de PyCharm ejecute el archivo Comparador.py
			Dé click en el botón Mostrar Resultados, con esto se visualizarán los resultados finales
