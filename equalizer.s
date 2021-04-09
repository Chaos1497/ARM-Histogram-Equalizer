@ Registro R7 reservado para manipulación de archivos
@ Código de llamadas al sistema: https://github.com/torvalds/linux/blob/v4.17/arch/arm/tools/syscall.tbl#L17
@ Parámetros para manipulación de archivos: https://syscalls.w3challs.com/?arch=arm_strong
@ Set de instrucciones ARM: https://www.csie.ntu.edu.tw/~cyy/courses/assembly/10fall/lectures/handouts/lec09_ARMisa.pdf
@ Para rangos de offset: https://developer.arm.com/documentation/dui0552/a/the-cortex-m3-instruction-set/memory-access-instructions/ldr-and-str--immediate-offset

.text
.global _start

_start: 
	ldr R0, =txtPixeles  @carga el archivo de pixeles precargados
	mov R1, #2  @ #2 indica modo de lectura/escritura, ver tercer comentario inicial
	mov R7, #5  @ #5 indica la apertura del archivo , ver segundo comentario inicial
	swi 0
	add R8, R0, #0
	ldr R9, =307200
	b _cargarROM

_cargarROM:
	cmp R9, #0
	beq _cargarPixeles
	sub R9, R9, #1 @ decrementa indice
	ldr R1, =conversor @ se agarra puntero a donde se van a meter los valores
	mov R2, #3 
	mov R7, #3 @ #5 indica lectura del archivo , ver segundo comentario inicial
	swi 0
	bl _strToInt @ necesito convertir los valores a enteros para poder analizarlos
	ldr R2, =memROM
	add R2, R2, R5
	add R5, R5, #1 @ se va incrementando el puntero por 1 byte
	strb R4, [R2, #0]
	b _cargarROM

_cargarPixeles:
	cmp R9, #255 @ Si llega al ultimo valor, empieza a calcular frecuencias
	beq _frec
	ldr R0, =valorMaxPix @ De lo contrario, sigue extrayendo pixeles
	strb R9, [R0, R9] @ Y los guarda en R9
	add R9, R9, #1
	b _cargarPixeles

@ frec, frecFila y frecColumna funcionan como un for i y luego for j de python
_frec:
	mov R9, #0
	ldr R7, =307200 @ cantidad de pixeles por analizar
	ldr R4, =frecuencia 
	b _frecFila

_frecFila:
	cmp R9,#256
	beq _acumFrec
	mov R8,#0 @ j=0
	mov R2,#0 @ mi contador de frecuencia
	b _frecColumna

_frecColumna:
	cmp R8,R7 @ condicion de parada
	beq _guardarEnFinal
	ldr R10, =memROM @ carga en R10 la memoria con los pixeles precargados
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
	ldr R2, =frecuencia @ frecuencias de tabla 1
	ldr R3, =frecuenciaAcum @ frecuencias de tabla 2
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
	ldr R1, =1204  @ valorMaxPix/255
	ldr R2, = frecuenciaDist @ frecuencias de tabla 3
	ldr R3, =frecuenciaDistAcum @ frecuencias de tabla 4
	mov R4,#0  @ acumulado	
	bl _frecDistAux
	ldr R9, =307200 @ carga valor maximo
	sub R5,R9,R4 @ agarro la diferencia
	str R5,[R2,#0] @ guardo el ultimo valor que completa la cuenta
	str R9,[R3,#0] @ guarda valor total en frecuenciaDistAcum
	b _remapeoInicial
	
_frecDistAux:
	cmp R9,#254 
	bxeq lr
	str R1,[R2,#0] @ guarda valor
	add R4,R4,R1 @ incremento acumulador
	str R4,[R3,#0] @ guarda acumulado
	add R2,R2,#4 @ aumenta frecuenciaDist
	add R3,R3,#4 @ aumenta frecuenciaDistAcum
	add R9,R9,#1 @ incrementa contador
	b _frecDistAux

_cargarEnFinal:
	ldr R0, =txtPixelesNuevos @carga el archivo de pixeles re-mapeados
	mov R1,#2 @ #2 indica modo de lectura/escritura, ver tercer comentario inicial
	mov R7,#5 @ #5 indica la apertura del archivo , ver segundo comentario inicial
	swi 0
	add R6,R0,#0 @ genera una copia
	ldr R9,=307200
	mov R3,#0
	b _cargarEnFinalAux
	
_cargarEnFinalAux:
	add R0, R6, #0 @ cargo la copia
	cmp R9, #0
	beq _final       
	sub R9, R9, #1
	ldr R1, =memROM @cargo la memoria ROM
	add R1, R1, R3
	mov R10, #0
	ldrb R10, [R1,#0] @ carga solo 1 byte
	bl _intToStr @ necesito convertir enteros en string para guardar en el txt
	ldr R1, =auxiliar @ carga en R1 el puntero al valor modificado
	add R3, R3, #1 
	mov R2, #8 @ escribo 8 bytes
	mov R7, #4 @ #4 indica escritura del archivo , ver segundo comentario inicial
	swi 0 
	add R0, R6, #0 @ cargo la copia de nuevo
	ldr R1, =salto @ escribo un salto de linea para separar los valores
	mov R2, #1 @ #1 indica modo de lectura, ver tercer comentario inicial
	mov R7, #4 @ #4 indica escritura del archivo , ver segundo comentario inicial
	swi 0
	b _cargarEnFinalAux
	
_remapeoInicial:
	mov R9, #0 @ mi contador de valores
	ldr R0, =mappingByte @ carga en R0 la lista de pixeles por mapear
	ldr R6, =frecuenciaAcum @ carga la frecuencia acumulada de la tabla 2
	b _remapeoInicialFila
	
_remapeoInicialFila:
	cmp R9,#255 @ condicion de parada
	beq _remapeoFinal
	add R9,R9,#1 @ suma 1 al contador
	mov R8, #0
	ldr R5, [R6, #0]
	add R6, R6, #4
	ldr R4, =frecuenciaDistAcum
	ldr R7,=listaDif
	b _remapeoInicialColumna

_remapeoInicialColumna:
	cmp R8, #255
	beq _buscarMenor
	add R8, R8, #1
	ldr R1, [R4, #0]
	cmp R1, R5
	sublt R10, R5, R1
	subgt R10, R1, R5
	str R10, [R7]
	add R7, R7, #4
	add R4, R4, #4
	b _remapeoInicialColumna

_buscarMenor:
	ldr R7, =listaDif
	ldr R4, =307200
	mov R8, #0
	mov R11,#0
	b _buscarMenorAux
	
_buscarMenorAux:
	cmp R8, #255
	beq _pixelStrMap
	ldr R10, [R7]
	add R7, R7, #4
	cmp R4, R10
	addgt R4, R10, #0
	addgt R11, R8, #0
	add R8, R8, #1
	b _buscarMenorAux

_pixelStrMap:
	strb R11, [R0, #0]
	add R0, R0, #1
	mov R8, #0
	b _remapeoInicialFila

_remapeoFinal:
	ldr R0, =memROM @ cargo la la ROM de pixeles iniciales
	ldr R1, =307200 @ cargo la cantidad de pixeles totales
	b _remapeoFinalAux

_remapeoFinalAux:
	cmp R1, #0 @ condicion de parada
	beq _cargarEnFinal
	ldrb R2, [R0, #0] 
	mov R3, #0
	ldr R4, =mappingByte
	bl _remapeoFinalAux2
	add R0, R0, #1
	sub R1, R1, #1
	b _remapeoFinalAux
	
_remapeoFinalAux2:
	cmp R3, #255 @condicion de parada
	bxeq lr @ return si llegó al final
	cmp R3, R2 @los comparo
	ldreqb R8, [R4] @ cargo el byte de R4 en R8
	streqb R8, [R0] @ almaceno en R0 el valor que hay en R8
	add R4, R4, #1 @ siguiente byte
	add R3, R3, #1 @ siguiente valor
	b _remapeoFinalAux2
	
_strToInt:
	ldr R11, =conversor @se carga puntero del valor leido
	ldrb R1, [R11, #2]
	sub R4, R1, #'0' @ se pasa a decimal
	ldr R11, =conversor
	ldrb R1, [R11, #1] @ se agarra en R1 el char que sigue
	mov R11, #10 @ paso a la segunda posicion del conversor
	sub R1, R1, #'0' @ se pasa a decimal
	mul R6, R1, R11 
	add R4, R4, R6 @ suma el 2do digito sacado a R4
	ldr R11, =conversor
	ldrb R1, [R11, #0] @ carga el byte en R1
	mov R11, #100 @ paso a la tercera posicion del conversor
	sub R1, R1, #'0' @ se pasa a decimal
	mul R6, R1, R11
	add R4, R4, R6
	bx lr

_intToStr:
	lsl R10, R10, #24
	lsr R10, R10, #24
	ldr R12, =auxiliar
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #24 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #0]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #25 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #1]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #26 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #2]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #27 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #3]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #28 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #4]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #29 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #5]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #30 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #6]
	
	mov R1, #0
	add R1, R10, #0
	lsl R1, R1, #31 @desplazo para correr el bit que ocupo
	lsr R1, R1, #31 @desplazo para poner el bit
	add R1, R1, #'0'
	strb R1, [R12, #7]
	
	bx lr

_final:
	mov R7, #1 @ #1 indica llamada al sistema exit
	swi 0

.data
	salto: .asciz "\n" @ variable para separar pixeles en el archivo final
	txtPixeles: .asciz "pixPrecargados.txt" @ archivo con pixeles precargados
	txtPixelesNuevos: .asciz "archivoRemapeo.txt" @ archivo con pixeles finales
	@ Rango de offset de 0-255 es de 1020, ver quinto comentario inicial
	listaDif: .space 1020, 0 @ lista de diferencias
	frecuencia: .space 1020,0 @ frecuencia de la tabla 1 en el enunciado
	frecuenciaAcum:  .space 1020,0 @ frecuencia de la tabla 2 en el enunciado
	frecuenciaDist: .space 1020,0 @ frecuencia de la tabla 3 en el enunciado
	frecuenciaDistAcum: .space 1020,0 @ frecuencia de la tabla 4 en el enunciado
	total: .4byte 307200  @varía con las dimensiones de la imagen
	mappingByte: .space 255,0 @ byte para ir guardando los pixeles finales
	valorMaxPix: .byte 255 @ valor maximo para un pixel
	auxiliar: .asciz "00000000" @auxiliar para hacer cambio de int a str
	conversor: .asciz "000" @ Para conversiones varias
	memROM: .space 307200,0  @varía con las dimensiones de la imagen
