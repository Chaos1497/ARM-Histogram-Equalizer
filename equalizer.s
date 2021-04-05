.text
.global _start

_start: @carga el archivo de inicio
	ldr R0, =imgTxt
	mov R1,#2
	mov R7,#5
	swi 0
	add R8,R0,#0 @ guarda el descriptor en R8, por si acaso
	ldr R9,=307200
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
	ldr R7,=307200 @ R7 va a ser el largo del archivo para j
	ldr R4,=frecuencias  @carga puntero a arreglo
	b _frecAuxI

_frecAuxI:
	cmp R9,#256
	beq _acumFrec
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
	str R2, [R4,#0]
	add R4,R4,#4
	add R9,R9,#1
	b _frecAuxI

_acumFrec:
	mov R9,#0
	ldr R2, =frecuencias
	ldr R3, =frecuenciasAcum
	mov R4,#0 @ registro para cargar la frecuencia
	mov R5,#0 @ registor para acumular
	b _acumFrecAux
	
_acumFrecAux:
	cmp R9,#256
	beq _frecDistribuir
	add R9,R9,#1 @ incrementa indice
	ldr R4,[R2,#0] @ cargo la frecuencia
	add R2,R2,#4 @ incrementa el puntero
	add R5,R5,R4 @ acumula
	str R5,[R3,#0] @ guarda acumulado
	add R3,R3,#4 @incrementa puntero
	b _acumFrecAux
	
_frecDistribuir:
	mov R9,#0
	ldr R1, =662 @ valor fijo
	ldr R2, = frecuenciasDistr @ carga puntero
	ldr R3, =frecuenciasDistrAcum @ carga puntero al otro arreglo de una vez
	mov R4,#0  @ acumulador 	
	bl _frecDistribuirAux
	ldr R9, =307200 @ carga valor maximo
	sub R5,R9,R4 @ agarro la diferencia
	str R5,[R2,#0] @guardo el ultimo valor que completa la cuenta
	str R9,[R3,#0] @ guarda valor total en frecuenciasDistrAcum
	b _dump

_frecDistribuirAux:
	cmp R9,#254 @ compara a uno menos, para el ultimo poner la diferencia y tener el valor completo
	bxeq lr
	str R1,[R2,#0] @ guarda valor
	add R4,R4,R1 @ incremento acumulador
	str R4,[R3,#0] @ guarda acumulador de una vez
	add R2,R2,#4 @ incrementa puntero a frecuenciasDistr
	add R3,R3,#4 @ incrementa puntero a frecuenciasDistrAcum
	add R9,R9,#1 @ incrementa contador
	b _frecDistribuirAux

__mapping:
	mov R9,#0 @ contador 
	mov R0,#0 @ 

_dump:
	ldr R0, =out @ carga eje.txt
	mov R1,#2 @ modo R&W
	mov R7,#5 @syscall para open
	swi 0
	add R8,R0,#0 @ respaldo del file descriptor
	ldr R9,=307200
	@mov R9,#255
	mov R3,#0
	b _dumpAux
	
_dumpAux:
	add R0,R8,#0 @ cargo el respaldo del file descriptor
	cmp R9,#0
	beq _c
	sub R9,R9,#1 @ decrementa indice
	ldr R1, =ram @ carga valor a escribir
	add R1,R1,R3 @ avanza en el puntero
	mov R10,#0
	@ldr R10,[R1,#0] @ carga en R1 el word en R10
	ldrb R10,[R1,#0] @ carga solo 1 byte
	bl _intToStr
	ldr R1,=intStr @ carga en R1 el puntero al valor modificado
	@add R3,R3,#4 @ incrementa el indice del puntero para word son 4 espacios
	add R3,R3,#1 @ para 1 byte solo 1
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
	lsr R10,R10,#8 @@limpia numero de los 8 primeros bits
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
	len: .4byte 307200
	ramAux: .asciz "123"
	intStr: .asciz "000000000000" @auxiliar para hacer cambio de int a str, valor maximo 24bytes 
	ram: .space 307200,0
	pixeles: .space 255,0
	frecuencias: .space 1020,0 @ frecuencias, usa 4 bytes para manejar words
	frecuenciasAcum:  .space 1020,0 @ frecuencias acumuladas, usa 4 bytes para manejar words
	frecuenciasDistr: .space 1020,0 @ frecuencias distribuidas, usa valor quemado por que depende de cantidad de pixeles
	frecuenciasDistrAcum: .space 1020,0 @ frecuencias distribuidas acumuladas
	pixelesMapeo: .space 255,0 @ vector para almacenar los pixeles mapeados
