@ Registro R7 reservado para manipulación de archivos
@ Código de llamadas al sistema: https://github.com/torvalds/linux/blob/v4.17/arch/arm/tools/syscall.tbl#L17
@ Parámetros para manipulación de archivos: https://syscalls.w3challs.com/?arch=arm_strong
@ Set de instrucciones ARM: https://www.csie.ntu.edu.tw/~cyy/courses/assembly/10fall/lectures/handouts/lec09_ARMisa.pdf
@ Para rangos de offset: https://developer.arm.com/documentation/dui0552/a/the-cortex-m3-instruction-set/memory-access-instructions/ldr-and-str--immediate-offset

.text
.global _start

_start: 
	ldr R0, =txtPixeles  @carga el archivo de pixeles precargados
	mov R1,#2  @ #2 indica modo de lectura/escritura, ver tercer comentario inicial
	mov R7,#5  @ #5 indica la apertura del archivo , ver segundo comentario inicial
	swi 0
	add R8,R0,#0
	ldr R9,=307200
	b _cargarROM

_cargarROM:
	cmp R9,#0
	beq _cargarPixeles
	sub R9,R9,#1 @ decrementa indice
	ldr R1, =conversor @ se agarra puntero a donde se van a meter los valores
	mov R2,#3 
	mov R7,#3 @ #3 indica la lectura del archivo
	swi 0
	bl _strToInt
	ldr R2, =memROM
	add R2,R2,R5
	add R5,R5,#1 @ se va incrementando el puntero por 1 byte
	strb R4,[R2,#0]
	b _cargarROM

_cargarPixeles:
	cmp R9,#255
	beq _frec
	ldr R0,=valorMaxPix
	strb R9,[R0,R9]
	add R9,R9,#1
	b _cargarPixeles

_frec:
	mov R9,#0
	ldr R7,=307200 @ cantidad de pixeles por analizar
	ldr R4,=frecuencia 
	b _frecFila

_frecFila:
	cmp R9,#256
	beq _acumFrec
	mov R8,#0 @ j=0
	mov R2,#0 @ mi contador de frecuencia
	b _frecColumna

_frecColumna:
	cmp R8,R7
	beq _guardarEnFinal
	ldr R10, =memROM
	add R10,R10,R8
	mov R1,#0
	ldrb R1,[R10] @ carga el primer byte de la ROM
	cmp R1,R9
	addeq R2,R2,#1 @ i+=1
	add R8,R8,#1 @ j+=1
	b _frecColumna
	
_guardarEnFinal:
	str R2, [R4,#0]
	add R4,R4,#4
	add R9,R9,#1
	b _frecFila

_acumFrec:
	mov R9,#0
	ldr R2, =frecuencia
	ldr R3, =frecuenciaAcum
	mov R4,#0 @ registro para cargar la frecuencia
	mov R5,#0 @ registor para acumular
	b _acumFrecAux
	
_acumFrecAux:
	cmp R9,#256
	beq _frecDist
	add R9,R9,#1 @ incrementa indice
	ldr R4,[R2,#0] @ cargo la frecuencia
	add R2,R2,#4 @ incrementa el puntero
	add R5,R5,R4 @ acumula
	str R5,[R3,#0] @ guarda acumulado
	add R3,R3,#4 @incrementa puntero
	b _acumFrecAux
	
_frecDist:
	mov R9,#0
	ldr R1, =division @ valor fijo
	ldr R2, = frecuenciaDist @ carga puntero
	ldr R3, =frecuenciaDistAcum @ carga puntero al otro arreglo de una vez
	mov R4,#0  @ acumulador 	
	bl _frecDistAux
	ldr R9, =307200 @ carga valor maximo
	sub R5,R9,R4 @ agarro la diferencia
	str R5,[R2,#0] @guardo el ultimo valor que completa la cuenta
	str R9,[R3,#0] @ guarda valor total en frecuenciaDistAcum
	b _cargarEnFinal

_frecDistAux:
	cmp R9,#254 @ compara a uno menos, para el ultimo poner la diferencia y tener el valor completo
	bxeq lr
	str R1,[R2,#0] @ guarda valor
	add R4,R4,R1 @ incremento acumulador
	str R4,[R3,#0] @ guarda acumulador de una vez
	add R2,R2,#4 @ incrementa puntero a frecuenciaDist
	add R3,R3,#4 @ incrementa puntero a frecuenciaDistAcum
	add R9,R9,#1 @ incrementa contador
	b _frecDistAux

__mapping:
	mov R9,#0 @ contador 
	mov R0,#0

_cargarEnFinal:
	ldr R0, =txtPixelesNuevos @ carga eje.txt
	mov R1,#2 @ modo R&W
	mov R7,#5 @syscall para open
	swi 0
	add R8,R0,#0 @ respaldo del file descriptor
	ldr R9,=307200
	mov R3,#0
	b _cargarEnFinalAux
	
_cargarEnFinalAux:
	add R0,R8,#0 @ cargo el respaldo del file descriptor
	cmp R9,#0
	beq _final
	sub R9,R9,#1 @ decrementa indice
	ldr R1, =memROM @ carga valor a escribir
	add R1,R1,R3
	mov R10,#0
	ldrb R10,[R1,#0] @ carga solo 1 byte
	bl _intToStr
	ldr R1,=auxiliar @ carga en R1 el puntero al valor modificado
	add R3,R3,#1 @ para 1 byte solo 1
	mov R2,#12 @ quiero escribir 12 bytes
	mov R7,#4 @ #4 indica escritura del archivo , ver segundo comentario inicial
	swi 0 
	add R0,R8,#0 @ write devuelve un valor en R0, entoces se tiene que volver a cargar el respaldo de fd
	ldr R1,=espacio @ escribe un '\n' para dividirlos
	mov R2,#1
	mov R7,#4 @ #4 indica escritura del archivo , ver segundo comentario inicial
	swi 0
	b _cargarEnFinalAux
	
_strToInt:
	ldr R10,=conversor @se carga puntero del valor leido
	ldrb R1,[R10,#2]
	sub R4,R1,#'0' @ se pasa a decimal y se guarda en R4
	ldr R10,=conversor
	ldrb R1,[R10,#1] @ se agarra en R1 el char que sigue
	mov R10,#10
	sub R1,R1,#'0' @ se pasa a decimal
	mul R7,R1,R10 
	add R4,R4,R7 @ suma el 2do digito sacado a R4
	ldr R10,=conversor
	ldrb R1,[R10,#0] @se carga el byte que hay ahi, en R1
	mov R10,#100
	sub R1,R1,#'0'
	mul R7,R1,R10
	add R4,R4,R7
	bx lr

@ Funcion que convierte un entero a una representacion para usar en string de 2 en 2 bits
_intToStr:
	lsl R10,R10,#8 @ Se limpia R10
	lsr R10,R10,#8 
	ldr R12,=auxiliar
	mov R1,#0
	add R1,R10,#0 
	lsr R1,R1,#22
	add R1,R1,#'0'
	strb R1,[R12,#0] @ mete primeros 2 bits
	mov R1,#0
	add R1,R10,#0 @@ segundos 2bits
	lsl R1,R1,#10
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#1]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#12
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#2]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#14
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#3]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#16
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#4]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#18
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#5]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#20
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#6]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#22
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#7]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#24
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#8]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#26
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#9]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#28
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#10]
	mov R1,#0
	add R1,R10,#0
	lsl R1,R1,#30
	lsr R1,R1,#30
	add R1,R1,#'0'
	strb R1,[R12,#11]
	bx lr
	

_final:
	mov R7, #1 @ #1 indica llamada al sistema exit
	swi 0

.data
	espacio: .asciz "\n"
	txtPixeles: .asciz "pixPrecargados.txt"
	txtPixelesNuevos: .asciz "archivoFinal.txt"
	@ Rango de offset de 0-255 es de 1020, ver quinto comentario inicial
	frecuencia: .space 1020,0 @ frecuencia de la tabla 1 en el enunciado
	frecuenciaAcum:  .space 1020,0 @ frecuencia de la tabla 2 en el enunciado
	frecuenciaDist: .space 1020,0 @ frecuencia de la tabla 3 en el enunciado
	frecuenciaDistAcum: .space 1020,0 @ frecuencia de la tabla 4 en el enunciado
	total: .4byte 307200  @varía con las dimensiones de la imagen
	valorMaxPix: .space 255,0
	division: .space 301,0  @ valorMaxPix/255
	auxiliar: .asciz "000000000000" @auxiliar para hacer cambio de int a str, valor maximo 24bytes
	conversor: .asciz "000" @ Para conversiones varias
	memROM: .space 307200,0  @varía con las dimensiones de la imagen
	pixelesMapeo: .space 255,0 @ vector para almacenar los pixeles mapeados
