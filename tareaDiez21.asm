;=======================================================================|
; Para la gestion de un inventario sencillo haciendo uso de lenguaje    |
; "ensamblador" en su version MASM para 16 bits progrado en entorno     |
; linux[Debian-Jessie 64 bits, haciendo uso de WINE y emu8086           |
;=======================================================================|
; UNIVERSIDAD DE EL SALVADOR FMOcc                                      |
; Docente.: Ing. Carlos Stanley Linares Paula                           |
;=======================================================================|
;    ALUMNOS:                                                           |
; GG13008 Sigfrido Ernesto Gómez Guinea                                 |
; PC10010 Edwin Omar Pacheco Calderon                                   |
;     Microprogramación 2017                                            |
;                                                                       |
;=======================================================================|



;======================================================================    
;              Aca definimos todas las macros a utilizar
;======================================================================    
 
;----------------------------------------------------------------------
;               Macro para mostrar un menu recurrente
;---------------------------------------------------------------------- 
  macro menu 
    lea dx,mseleccione
    mov ah,9
    int 21h
    lea dx,mprimeravez
    mov ah,9
    int 21h
    lea dx,minventario
    mov ah,9
    int 21h
    lea dx,mcompra
    mov ah,9
    int 21h
    lea dx,mventa
    mov ah,9
    int 21h
    lea dx,msalir
    mov ah,9
    int 21h  
  endm 
;----------------------------------------------------------------------
;               Macro para la seleccion de opciones del menu
;----------------------------------------------------------------------  
  
  macro eleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, 's'
    je salirDeEjecucion
    cmp al,'0'
    je primeravez
    cmp al,'1'
    je revisarInventario
    cmp al,'2'
    je realizarCompra
    cmp al,'3' 
    je realizarVenta 
    limpiarpantalla
    lea dx, serrorseleccion
    mov ah,9
    int 21h
    pausa
    jmp inicio
  endm 

;----------------------------------------------------------------------
;               Macro para el submenu inventario
;----------------------------------------------------------------------  
  macro subMenuInventario
    lea dx,smiTitulo
    mov ah,9
    int 21h
    lea dx,smiVer
    mov ah,9
    int 21h
    lea dx,smiIngresar
    mov ah,9
    int 21h
    lea dx,smiVolver
    mov ah,9
    int 21h
    ;aca para las opciones de seleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, '1'
    je verInventario
    cmp al,'2'
    je ingresarPInventario
    cmp al,'v'
    je inicio 
    limpiarpantalla
    lea dx, serrorseleccion
    mov ah,9
    int 21h
    pausa
    jmp revisarInventario
    
  endm   
;----------------------------------------------------------------------
;               Macro para consultar el contenido de inventario
;----------------------------------------------------------------------  
  macro consultarInventario
        mov al, 2 
        mov dx, offset aInventario
        mov ah, 3dh 
        int 21h  ;Abre el archivo
        mov handle, ax
        mov si, 0 
        mov impInv, 0 ;Limpia el vector a imprimir 
        
        sigProducto:       
        mov bx, handle
        mov cx, 1
        mov dx, offset impInvSig
        mov ah, 3fh
        int 21h ;Que hace la 3fh, abre un archivo y toma su handle? :v
        cmp ax, 0
        jz finLecProducto
        mov dl, impInvSig[0]
        mov impInv[si], dl
        inc si
        jmp sigProducto
             
        finLecProducto:
        inc si
        mov impInv[si], 24h
        
        ;;;imprime aux
        lea dx, impInv
        mov ah,9
        int 21h;;imprime en pantalla la linea obtenida   
        mov bx, handle
	    mov ah, 3eh
	    int 21h ; close file...
	    mov al, 0
	    mov ah, 0
	    mov dx, 0
	    mov handle, 0
	    mov si, 0
	    mov impInv, 0
	    mov cx, 0
	    
        ;jmp menu 
  endm
   



;----------------------------------------------------------------------
;               Macro para limpiar la pantalla y definir un color :v
;----------------------------------------------------------------------  
  macro limpiarPantalla
    MOV ax,0600h ; Peticion para limpiar pantalla
    MOV bh,4FH  ;pantalla blaca{0F}, letra negra{0}
    MOV cx,0000h ; Se posiciona el cursor en Ren=0 Col=0
    MOV dx,184Fh ; Cursor al final de la pantalla Ren=24(18) 
    INT 10H 
    MOV ah,02h 
    MOV bh,00 
    MOV dh,0 
    MOV dl,0 
    INT 10h
  endm  
;----------------------------------------------------------------------
;     Cuando es la primera vez, lo usamos para crear los archivos
;----------------------------------------------------------------------  
  macro primeravezarchivos
    mov dx, offset directorio
    mov ah, 39h
    int 21h ;Se crea el directorio en la ruta especificada
    ;aca se crean y escribe en los archivos
    ;archivo inventario
    mov ah, 3ch
    mov cx, 0
    mov dx, offset ainventario
    int 21h
    jc err
    mov handle, ax
    ;Crea 
    mov ah, 40h
    mov bx, handle
    mov dx, offset tiainventario
    mov cx, tiainventario_tam
    int 21h
    ;close c:\emu8086\vdrive\C\archivo\inventario.txt
    mov ah, 3eh
    mov bx, handle
    int 21h
    ;archivo compra
    mov ah, 3ch
    mov cx, 0
    mov dx, offset acompra
    int 21h
    jc err
    mov handle, ax
    ;crea
    mov ah, 40h
    mov bx, handle
    mov dx, offset tiacompra
    mov cx, tiacompra_tam
    int 21h
    ; close c:\emu8086\vdrive\C\archivo\compra.txt
    mov ah, 3eh
    mov bx, handle
    int 21h
    ;archivo venta
    mov ah, 3ch
    mov cx, 0
    mov dx, offset aventa
    int 21h
    jc err
    mov handle, ax
    ; crea
    mov ah, 40h
    mov bx, handle
    mov dx, offset tiaventa
    mov cx, tiaventa_tam
    int 21h
    ; close c:\emu8086\vdrive\C\archivo\venta.txt
    mov ah, 3eh
    mov bx, handle
    int 21h
    err:
    nop  
  endm 
;----------------------------------------------------------------------
;      Macro para generar una pausa intencional en la ejecucion
;----------------------------------------------------------------------       
       
  macro pausa
    lea dx, spausa
    mov ah,9
    int 21h
    mov ah,1
    int 21h
  endm 
;----------------------------------------------------------------------
;       Para escribir algo en el archivo inventario(hay que generalizar)   
;----------------------------------------------------------------------  

    ;desde aca hasta::::::::::--------------------->
 macro ingresarInventario
    mov si,0
    xor  vecInventario,0 
    pedirInventario:
    mov ah,1
    int 21h
    mov vecInventario[si],al
    inc si
    cmp al,13
    je okInv
    jmp pedirInventario
    ;Logica de escritura 
    okInv:
    escribirInventario vecInventario   
 endm   
     
;----------------------------------------------------------------------
;       Para escribir lo ingresado en el archivo inventario
;----------------------------------------------------------------------     
 macro escribirInventario vector
    limpiarpantalla
    editarInventario:
    mov ah,3dh
    mov al,2h
    mov dx, offset ainventario
    int 21h  ;abre el archivo a escribir
    jc notificarerror ;por que hay error
    ;en ax el handle del archivo
    mov handle,ax 
    mov ah,42h
    mov al,02h
    mov bx, handle
    mov cx,0
    mov dx,0
    int 21h ;mueve el puntero al final del documento :v 
    ;Sigfrid fue :v          
    mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    mov cx,si
    mov dx, offset vector
    mov ah,40h
    int 21h   ;Escribe en el archivo la cadena ingresada
    mov cx,1
    mov dx, offset nuevaLinea
    mov ah,40h
    int 21h   ;Escribe en el archivo un enter
     
    limpiarPantalla
    lea dx, exito
    mov ah,9
    int 21h
    mov ah, 3eh
    int 21h  ;cierra archivo mostrando un mensaje de exito
    endm
;----------------------------------------------------------------------
;       Fin de las macros :v
;----------------------------------------------------------------------     
          
;#####################################################################
;      Aca inicia el programa en si
;#####################################################################         

;*********************************************************************
;    Aca se declaran las variables a utilizar
;*********************************************************************
data segment
    ;Mensajes del menu m
    msalir db "presiona s para salir...",10,13,"$"
    mseleccione db "Presione el numero de lo que desea hacer:",10,13,"$"                 
    mprimeravez db "-0-. Si es primera vez, si no esta seguro que es primera vez, no lo use!",10,13,"$"
    minventario db "-1-. Gestion Inventario",10,13,"$"
    mcompra db "-2-. Gestion Compra",10,13,"$"
    mventa db  "-3-. Gestion Venta",10,13,"$"
    mSalidaDeEjecucion db "gracias por usarme, presiona una tecla para salir",10,13,"$"
    
    ;Mensajes de las opciones selecionadas s 
    sprimeravez db "Felicidades, se han creado sus archivos de gestion",10,13,"$"
    sinventario db "Esta viendo el inventario",10,13,"$"
    scompra db "Esta Realizando una compra",10,13,"$"
    sventa db  "Esta realizanco una venta",10,13,"$"
    serrorseleccion db "Opcion no encontrada, intente de nuevo",10,13,"$"
    spausa db "Presione cualquier tecla para reanudar",10,13,"$"
     
    ;Mensajes del submenu inventario
    smiTitulo db "Que deseas hacer, presiona el numero",10,13,"$"
    smiVer db "-1-. Ver/Consultar inventario",10,13,"$"
    smiIngresar db "-2-. Ingresar un nuevo producto",10,13,"$"
    smiVolver db "-v-. Volver",10,13,"$"
     
    ;mensajes erorres y varios
    errordeescritura db "Error en la escritura",10,13,"$"
    exito db "Exito en la operacion",10,13,"$"
    espera db "En proceso, espera un momento",10,13,"$"
    ;Define el directorio, su ruta y los archivos  a
    ainventario db "c:\archivos\inventario.txt",0
    acompra db "c:\archivos\compra.txt",0
    aventa db "c:\archivos\venta.txt",0
    directorio db "c:\archivos",0 
    
    ;Define los texto iniciales de los archivos y su tamaño tia
    tiainventario db "    idProducto-nombre-costo-existencia",10,13 
    tiainventario_tam = $ - offset tiainventario
    tiacompra db "   codProducto-cantidad-pago-fecha",10,13
    tiacompra_tam = $ - offset tiacompra
    tiaventa db  "   codProducto-cantidad-pago-fecha",10,13
    tiaventa_tam = $ - offset tiaventa
   
    ;Lineas para saltos y vectores de ingreso
    vecInventario db 255 dup("$")
    nuevaLinea db 10,13
    
    ;El elemento magico
    handle dw 0
    handle1 dw 0
    
    ;variables utilitarias
    impInv db "$"
    impInvSig db "$"
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
;*********************************************************************
;    Aca inicia la parte ejecutable del programa
;*********************************************************************

start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    inicio: ;Aca se imprimie el menu
    limpiarPantalla
    menu
    eleccion
     
    ;Aca van las operaciones con archivos

;======================================================================   
    primeravez: ;crearia los archivos si es primera vez 
    limpiarPantalla
    primeravezarchivos;Crea los archivos a usarse si es primera vez
    lea dx, sprimeravez
    mov ah,9
    int 21h ;Crea los archivos de gestion
    pausa
    jmp inicio:
;======================================================================    
;              Aca se trabaja el inventario
;======================================================================    
    
    revisarInventario: ;Muestra el subMenu Inventario
        limpiarPantalla
        subMenuInventario
        pausa
        jmp inicio 
    
    ingresarPInventario:
        limpiarPantalla
        ingresarInventario ;Trabajar en como se ingresa
        pausa
        jmp revisarInventario    
        
    verInventario:
        limpiarPantalla
        lea dx, sinventario
        mov ah,9
        int 21h ;muestra el mensaje
        consultarInventario
        pausa 
        jmp revisarInventario

;======================================================================    
;              Aca se trabajan las compras
;======================================================================    

    
    realizarCompra:    ;Aca se realiza una compra
    limpiarPantalla
    lea dx, scompra
    mov ah,9
    int 21h
    pausa
    jmp inicio    

;======================================================================    
;              Aca se trabajan las ventas
;======================================================================    

    
    realizarVenta:     ;Aca se realiza una venta
    limpiarPantalla
    lea dx, sventa
    mov ah,9
    int 21h  
    pausa
    jmp inicio
    
    notificarerror:
    lea dx, errordeescritura
    mov ah,9
    int 21h
    pausa
    jmp inicio    
              
              
;======================================================================    
;              Estas son las lineas finales
;======================================================================    
              
    salirDeEjecucion:  ;Salida de la ejecucion
    limpiarPantalla
    lea dx, mSalidaDeEjecucion   
    mov ah, 9
    int 21h 
    mov ah, 1
    int 21h
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends 
;======================================================================    
;              Lineas de reservoir borrar al final de la creacion
;======================================================================    


;mov ah,3dh
;mov al, 0h lectura, 1h escritura, 2 r&w
;mov dx, offset nombrearchivo
;int 21h
;mov ah 3fh para leer archivo
;mov bx,ax
;mov cx,10
;mov dx, offset vec
;int 21h
;mov ah,9
;int 21h
;mov ah, 3eh
;int 21h cierra archivo 
;para pedir archivo
;pedir:
;mov ah,1
;int 21
;mov vec[si],al
;inc si
;cmp al,0dh
;ja pedir
;jb pedir

;editar:
;mov ah,3dh
;mov al,1h
;mov dx, offset nombre
;int 21h
;jc salir por que hay error
;mov bx,ax
;mov cx,si size de caracteres a grabar
;mov ah,40h
;int 21h
;imprime msaj  macro de creado
;mov ah, 3eh
;int 21h  ;cierra archivo


end start ; set entry point and stop the assembler.
        
        
3dh para abrir
mov ah,3dh
mov al, 0h ;0h abrir, 1 lectura, 2 para ambos

mov ah,1
int 21h
mov vec[si],al
inc si
cmp al,0dh
ja pedir
jb pedir

mov ah, 3dh
mov al, 1h
mov dx, offset nombre
int 21h
jc salir
mov bx,ax
mov cx,si
mod dx,offset vec
mov ah,40h
 int 21h

mov ah, 3eh
int 21h
jmp menu