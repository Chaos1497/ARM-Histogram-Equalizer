.text
.global _start

_start: @carga el archivo de inicio
	ldr R0, =imgTxt
	mov R1,#2
	mov R7,#5
	swi 0
	add R8,R0,#0 @ guarda el descriptor en R8, por si acaso
	ldr R9,=169034
	b _loadToRam

_loadToRam:
	cmp R9,#0
	beq _fillPixels
	sub R9,R9,#1 @ decrementa indice
	ldr R1, =ramAux @ se agarra puntero a donde se van a meter los valores
	mov R2,#3 @ se leen solo 3 bytes del archivo
	mov R7,#3
	swi 0
	bl _strValueToInt
	ldr R2, =ram
	add R2,R2,R5 @ lo incrementa  por R5
	add R5,R5,#1 @ se va incrementando el puntero por 1 byte
	strb R4,[R2,#0]
	b _loadToRam

_fillPixels:@@ carga pixeles [0,...,255] en espacio -> pixeles
	cmp R9,#255
	beq _frec
	ldr R0,=pixeles
	strb R9,[R0,R9]
	add R9,R9,#1
	b _fillPixels

_frec:
	mov R9,#0 @ R9 va a ser i = 0, para comparar hasta 255 y de paso se puede usar como referencia
	ldr R7,=169034 @ R7 va a ser el largo del archivo para j
	ldr R4,=frecuencias  @carga puntero a arreglo
	b _frecAuxI

_frecAuxI:
	cmp R9,#256
	beq _dump
	mov R8,#0 @ R8 va a ser j = 0 hasta R7
	mov R2,#0 @ mi contador de frecuencias
	b _frecAuxJ

_frecAuxJ:
	cmp R8,R7
	beq _regToRam
	ldr R10, =ram @ carga valor a leer
	add R10,R10,R8 @ avanza en el puntero
	mov R1,#0
	ldrb R1,[R10] @ carga en R1 el byte a comparar R10
	cmp R1,R9
	addeq R2,R2,#1 @incrementa R2 si es igual
	add R8,R8,#1 @ incrementa j
	b _frecAuxJ
	
_regToRam:
@@	strb R2,[R4,#0] @ agarra el byte menos significativo
@	lsr R2,R2,#8 @ le hace shift para obtener las cifras del siguiente byte
@	strb R2,[R4,#1] @ guarda el byte de esas cifras
@	lsr R2,R2,#8 @ le hace shift para obtener las cifras del siguiente byte
@	strb R2,[R4,#2] @mismo
	str R2, [R4,#0]
	add R4,R4,#4
	add R9,R9,#1
	b _frecAuxI

_dump:
	ldr R0, =out @ carga eje.txt
	mov R1,#2 @ modo R&W
	mov R7,#5 @syscall para open
	swi 0
	add R8,R0,#0 @ respaldo del file descriptor
	ldr R9,=169034
	mov R9,#255
	mov R3,#0
	b _dumpAux
	
_dumpAux:
	add R0,R8,#0 @ cargo el respaldo del file descriptor
	cmp R9,#0
	beq _c
	sub R9,R9,#1 @ decrementa indice
	ldr R1, =frecuencias @ carga valor a escribir
	add R1,R1,R3 @ avanza en el puntero
	mov R10,#0
	ldr R10,[R1,#0] @ carga en R1 el word en R10
@	lsl R10,R10,#16
@	mov R2,#0
@	ldrb R2,[R1,#1]
@	lsl R2,R2,#8
@	add R2,R10,R2
@	mov R10,#0
@	ldrb R10,[R1,#2]
@	add R10,R10,R2
	bl _intToStr
	ldr R1,=intStr @ carga en R1 el puntero al valor modificado
	add R3,R3,#4 @ incrementa el indice del puntero
	mov R2,#12 @ quiero escribir 12 bytes
	mov R7,#4 @ codigo de syscall
	swi 0 
	add R0,R8,#0 @ write devuelve un valor en R0, entoces se tiene que volver a cargar el respaldo de fd
	ldr R1,=espacio @ escribe un '\n' para dividirlos
	mov R2,#1
	mov R7,#4
	swi 0
	b _dumpAux

_c:
	mov R7, #1
	swi 0

_intToStr:@ entrada R10, salida etiqueta intStr, convierte un entero a una representacion para usar en string de 2bits en 2bits se puede hacer de 3 bits en 3 y reducir ciclos
	lsl R10,R10,#8
	lsr R10,R10,#8 @@limpia numero 
	ldr R11,=intStr
	mov R1,#0
	add R1,R10,#0 @@ lo mete en R1
	lsr R1,R1,#22
	add R1,R1,#'0'
	strb R1,[R11,#0] @ mete primeros 2 bits
	mov R1,#0
	add R1,R10,#0 @@ segundos 2bits
	lsl R1,R1,#10
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#1]
	mov R1,#0
	add R1,R10,#0 @@ 3
	lsl R1,R1,#12
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#2]
	mov R1,#0
	add R1,R10,#0 @@ 4
	lsl R1,R1,#14
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#3]
	mov R1,#0
	add R1,R10,#0 @@ 5
	lsl R1,R1,#16
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#4]
	mov R1,#0
	add R1,R10,#0 @@ 6
	lsl R1,R1,#18
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#5]
	mov R1,#0
	add R1,R10,#0 @@ 7
	lsl R1,R1,#20
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#6]
	mov R1,#0
	add R1,R10,#0 @@ 8
	lsl R1,R1,#22
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#7]
	mov R1,#0
	add R1,R10,#0 @@ 9
	lsl R1,R1,#24
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#8]
	mov R1,#0
	add R1,R10,#0 @@ 10
	lsl R1,R1,#26
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#9]
	mov R1,#0
	add R1,R10,#0 @@ 11
	lsl R1,R1,#28
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#10]
	mov R1,#0
	add R1,R10,#0 @@ 12
	lsl R1,R1,#30
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R11,#11]
	bx lr
	
_strValueToInt:
	ldr R10,=ramAux @se carga puntero del valor leido
	ldrb R1,[R10,#2]
	sub R4,R1,#'0' @ se pasa a decimal y se guarda en R4
	ldr R10,=ramAux
	ldrb R1,[R10,#1] @ se agarra en R1 el char que sigue
	mov R10,#10
	sub R1,R1,#'0' @ se pasa a decimal
	mul R7,R1,R10 
	add R4,R4,R7 @ suma el 2do digito sacado a R4
	ldr R10,=ramAux
	ldrb R1,[R10,#0] @se carga el byte que hay ahi, en R1
	mov R10,#100
	sub R1,R1,#'0'
	mul R7,R1,R10
	add R4,R4,R7
	bx lr

.data
	espacio: .asciz "\n"
	imgTxt: .asciz "output.txt"
	out: .asciz "archivoFinal.txt"
	len: .4byte 169034
	ramAux: .asciz "123"
	intStr: .asciz "000000000000" @auxiliar para hacer cambio de int a str, valor maximo 24bytes 
	ram: .space 169034,0
	pixeles: .space 255,0
	frecuencias: .space 765,0 @ frecuencias peor de los casos puede ser un valor de 3bytes
	
@4 for write(where,what,len)
@5 for open(where,r/w) 0read,1write,2both
