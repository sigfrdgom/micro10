 ;=======================================================================|
; Para la gestion de un inventario sencillo haciendo uso de lenguaje    |
; "ensamblador" en su version MASM para 16 bits progrado en entorno     |
; linux[Debian-Jessie 64 bits, haciendo uso de WINE y emu8086           |
;=======================================================================|
; UNIVERSIDAD DE EL SALVADOR FMOcc                                      |
; Docente.: Ing. Carlos Stanley Linares Paula                           |
;=======================================================================|
;    ALUMNOS:                                                           |
; GG13008 Sigfrido Ernesto Gomez Guinea                                 |
; PC10010 Edwin Omar Pacheco Calderon                                   |
;     Microprogramacion 2017                                            |
;                                                                       |
;=======================================================================|



;======================================================================    
;              Aca definimos todas las macros a utilizar
;======================================================================    
                    
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de menu principal
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    
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
  
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de submenus
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

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
;               Macro para el submenu compra
;----------------------------------------------------------------------  
  macro subMenuCompra
    lea dx,smiTitulo
    mov ah,9
    int 21h
    lea dx,smcVer
    mov ah,9
    int 21h
    lea dx,smcIngresar
    mov ah,9
    int 21h
    lea dx,smcVolver
    mov ah,9
    int 21h
    ;aca para las opciones de seleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, '1'
    je verCompra
    cmp al,'2'
    je ingresarCompra
    cmp al,'v'
    je inicio 
    limpiarpantalla
    lea dx, serrorseleccion
    mov ah,9
    int 21h
    pausa
    jmp realizarCompra
    
  endm 
  
;----------------------------------------------------------------------
;               Macro para el submenu venta
;----------------------------------------------------------------------  
  macro subMenuVenta
    lea dx,smiTitulo
    mov ah,9
    int 21h
    lea dx,smvVer
    mov ah,9
    int 21h
    lea dx,smvIngresar
    mov ah,9
    int 21h
    lea dx,smvVolver
    mov ah,9
    int 21h
    ;aca para las opciones de seleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, '1'
    je verVenta
    cmp al,'2'
    je ingresarVenta
    cmp al,'v'
    je inicio 
    limpiarpantalla
    lea dx, serrorseleccion
    mov ah,9
    int 21h
    pausa
    jmp realizarVenta
    
  endm 
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de consultas
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  
;----------------------------------------------------------------------
;               Macro para consultar el contenido de inventario
;----------------------------------------------------------------------  
  macro consultarInventario
        
        
        
  endm

;----------------------------------------------------------------------
;               Macro para consultar el contenido de compra
;----------------------------------------------------------------------  
  macro consultarCompra
        
        
        
  endm
 
 
;----------------------------------------------------------------------
;               Macro para consultar el contenido de venta
;----------------------------------------------------------------------  
  macro consultarVenta
        
        
        
  endm

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de ingreso y escritura
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

;----------------------------------------------------------------------
;       Para escribir algo en el archivo inventario(hay que generalizar)   
;----------------------------------------------------------------------  

 macro ingresarInventario  ;aca el peo
    limpiarInventario ;Peligroso cuidado al usar
    
    imprimir iiCodigo
    mov cx,4
    mov si,0
        pedirCodigoInventario:
        mov ah,1
        int 21h
        cmp al,13
        je okCodigo:
        mov codigo[si],al
        inc si
        loop pedirCodigoInventario
    
    okCodigo:
    imprimir iiNombre
    mov cx,15
    mov si,0
        pedirNombreInventario:
        mov ah,1
        int 21h
        cmp al,13
        je okNombre:
        mov nombre[si],al
        inc si
        loop pedirNombreInventario
    
    okNombre:
    imprimir iiPrecio
    mov cx,3
    mov si,0
        pedirPrecioInventario:
        mov ah,1
        int 21h
        cmp al,13
        je okPrecio:
        mov precio[si],al
        inc si
        loop pedirPrecioInventario
    
    okPrecio:
    imprimir iiExistencia
    mov cx,3
    mov si,0
        pedirExistenciaInventario:
        mov ah,1
        int 21h
        cmp al,13
        je okExistencia:
        mov existencia[si],al
        inc si
        loop pedirExistenciaInventario
    
    okExistencia:
    
    escribirInventario codigo nombre precio existencia
  
    
 endm   
     
;----------------------------------------------------------------------
;       Para escribir lo ingresado[ingresarInventario] en el archivo inventario
;----------------------------------------------------------------------     
 macro escribirInventario cod nom pre exi   ;sin errores al guardar
    limpiarPantalla
    imprimir grabando
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
    ;mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    mov cx,4
    mov dx, offset cod
    mov ah,40h
    int 21h   ;Escribe en el archivo el codigo
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,15
    mov dx, offset nom
    mov ah,40h
    int 21h   ;Escribe en el archivo el nombre
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset pre
    mov ah,40h
    int 21h   ;Escribe en el archivo el precio
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset exi
    mov ah,40h
    int 21h   ;Escribe en el archivo la existencia
    mov cx,1
    mov dx, offset nuevaLinea
    mov ah,40h
    int 21h   ;Escribe en el archivo un enter
 
    limpiarPantalla
    lea dx, exitoInventario
    mov ah,9
    int 21h
    mov ah, 3eh
    int 21h ;cierra el archivo
    ;Funciona de buena manera
 endm 
  
;----------------------------------------------------------------------
;     Para escribir algo en el archivo compra, validar antes de esto?   
;----------------------------------------------------------------------  

 macro ingresarCompra  ;aca el peo
    limpiarCompra ;Peligroso cuidado al usar
    
    imprimir iiCodigo
    mov cx,4
    mov si,0
        pedirCodigoCompra:
        mov ah,1
        int 21h
        cmp al,13
        je okCodigoC:
        mov codigo[si],al ;variable
        inc si
        loop pedirCodigoCompra
    
    okCodigoC:
    realizarCompra codigo
    
    
    imprimir icCantidad
    mov cx,3
    mov si,0
        pedirCantidadC:
        mov ah,1
        int 21h
        cmp al,13
        je okCantidadC:
        mov cantidad[si],al  ;variable
        inc si
        loop pedirCantidadC
    
    okCantidadC:
    imprimir icPago
    mov cx,3
    mov si,0
        pedirPagoC:
        mov ah,1
        int 21h
        cmp al,13
        je okPagoC:
        mov pago[si],al   ;variable
        inc si
        loop pedirPagoC
    
    okPagoC:
    imprimir icFecha
    mov cx,10
    mov si,0
        pedirFechaC:
        mov ah,1
        int 21h
        cmp al,13
        je okFechaC:
        mov fecha[si],al  ;variable
        inc si
        loop pedirFechaC
    
    okFechaC:
    escribirCompra codigo cantidad pago fecha
 endm   
 
 
;------------------------------------------------------------------------
;       Para escribir lo ingresado[ingresarCompra] en el archivo compra
;------------------------------------------------------------------------     
 macro escribirCompra codC canC pagC fecC   ;sin errores al guardar
    limpiarPantalla
    imprimir grabando
    mov ah,3dh
    mov al,2h
    mov dx, offset acompra
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
    ;mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    mov cx,4
    mov dx, offset codC
    mov ah,40h
    int 21h   ;Escribe en el archivo el codigo
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset canC
    mov ah,40h
    int 21h   ;Escribe en el archivo el cantidad
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset pagC
    mov ah,40h
    int 21h   ;Escribe en el archivo el pago
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,10
    mov dx, offset fecC
    mov ah,40h
    int 21h   ;Escribe en el archivo la fecha
    mov cx,1
    mov dx, offset nuevaLinea
    mov ah,40h
    int 21h   ;Escribe en el archivo un enter
 
    limpiarPantalla
    lea dx, exitoCompra
    mov ah,9
    int 21h
    mov ah, 3eh
    int 21h ;cierra el archivo
    ;Funciona de buena manera
 endm         

 ;----------------------------------------------------------------------
;     Para escribir algo en el archivo venta, validar antes de esto?   
;----------------------------------------------------------------------  

 macro ingresarVenta  ;aca el peo
    limpiarVenta ;Peligroso cuidado al usar
    
    imprimir iiCodigo
    mov cx,4
    mov si,0
        pedirCodigoV:
        mov ah,1
        int 21h
        cmp al,13
        je okCodigoV:
        mov codigo[si],al ;variable
        inc si
        loop pedirCodigoV
    
    okCodigoV:
    realizarVenta codigo
    
    imprimir ivCantidad
    mov cx,3
    mov si,0
        pedirCantidadV:
        mov ah,1
        int 21h
        cmp al,13
        je okCantidadV:
        mov cantidad[si],al  ;variable
        inc si
        loop pedirCantidadV
    
    okCantidadV:
    imprimir ivPago
    mov cx,3
    mov si,0
        pedirPagoV:
        mov ah,1
        int 21h
        cmp al,13
        je okPagoV:
        mov pago[si],al   ;variable
        inc si
        loop pedirPagoV
    
    okPagoV:
    imprimir ivFecha
    mov cx,10
    mov si,0
        pedirFechaV:
        mov ah,1
        int 21h
        cmp al,13
        je okFechaV:
        mov fecha[si],al  ;variable
        inc si
        loop pedirFechaV
    
    okFechaV:
    escribirVenta codigo cantidad pago fecha
 endm   
 
 
;------------------------------------------------------------------------
;       Para escribir lo ingresado[ingresarVenta] en el archivo venta
;------------------------------------------------------------------------     
 macro escribirVenta codV canV pagV fecV   ;sin errores al guardar
    limpiarPantalla
    imprimir grabando
    mov ah,3dh
    mov al,2h
    mov dx, offset aventa
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
    ;mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    mov cx,4
    mov dx, offset codV
    mov ah,40h
    int 21h   ;Escribe en el archivo el codigo
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset canV
    mov ah,40h
    int 21h   ;Escribe en el archivo el cantidad
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,3
    mov dx, offset pagV
    mov ah,40h
    int 21h   ;Escribe en el archivo el pago
    mov cx,1
    mov dx, offset separater
    mov ah,40h
    int 21h   ;Escribe en el archivo un "-"
    mov cx,10
    mov dx, offset fecV
    mov ah,40h
    int 21h   ;Escribe en el archivo la fecha
    mov cx,1
    mov dx, offset nuevaLinea
    mov ah,40h
    int 21h   ;Escribe en el archivo un enter
 
    limpiarPantalla
    lea dx, exitoVenta
    mov ah,9
    int 21h
    mov ah, 3eh
    int 21h ;cierra el archivo
    ;Funciona de buena manera
 endm         

 
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de compra
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 

;----------------------------------------------------------------------
;      Macro de aprobacion para realizar una compra
;----------------------------------------------------------------------       
       
  macro realizarCompra codigo
    ;para buscar en la base da datos si el producto existe
     imprimir espera 
        mov coincidencias,0
        mov al,2
        mov dx, offset ainventario
        mov ah, 3dh
        int 21h
        mov handle,ax
        
        mov si,0
        mov bytesRcod,0 
        
            leerInvC: 
               mov bx, handle
               mov cx,1
               mov dx, offset lectura
               mov ah, 3fh
               int 21h  ;ABRE ARCHIVO
               cmp ax,0
               jz salidaC
               cmp lectura[0]," "
               je leerInvC
               cmp lectura[0],"-"
               je leerInvC  ;compara si es espacio o - para salir
               mov dl, lectura[0]
               cmp dl, codigo[si]
               je codExitosoC
               jne codNoExitosoC
               
               codExitosoC:
               inc si
               inc coincidencias
               cmp coincidencias,4 ;solo codigos de 4 digitos
               je  preSalidaC
               jmp leerInvC
               
               codNoExitosoC:
               mov si,0
               mov coincidencias,0
               jmp leerInvC  
          
     preSalidaC:
        mov coincidencias,999     
          
     salidaC: 
        cmp coincidencias,999
        jne noExisteC    
         
  endm   
  
  


;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de ventas
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
  ;----------------------------------------------------------------------
;      Macro de aprobacion para realizar una compra
;----------------------------------------------------------------------       
       
  macro realizarVenta codigo
    ;para buscar en la base da datos si el producto existe
     imprimir espera 
        mov coincidencias,0
        mov al,2
        mov dx, offset ainventario
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
        mov bytesRcod,0 
        
            leerInvV: 
               mov bx, handle
               mov cx,1
               mov dx, offset lectura
               mov ah, 3fh
               int 21h               
               cmp ax,0
               jz salidaV               
               cmp lectura[0]," "
               je leerInvV
               cmp lectura[0],"-"
               je leerInvV  ;compra si es espacio o - para salir               
               mov dl, lectura[0]
               cmp dl, codigo[si]
               je codExitosoV
               jne codNoExitosoV
                                          
               codExitosoV:
               inc si
               inc coincidencias
               cmp coincidencias,4 ;solo codigos de 4 digitos
               je  preSalidaV
               jmp leerInvV
               
               codNoExitosoV:
               mov si,0
               mov coincidencias,0
               jmp leerInvV  
          
     preSalidaV:
        mov coincidencias,999     
          
     salidaV: 
        cmp coincidencias,999
        jne noExisteV    
         
  endm                            
                             
                             
                             
                             
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de utilitarias
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

         
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
    mov bx, handle
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
    mov bx, handle
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
    mov bx, handle
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
;      Macro para imprimir un mensaje en cualquier parte del codigo
;----------------------------------------------------------------------       
       
  macro imprimir mensaje
    mov ax, data
    mov ds, ax
    mov ah,9
    lea dx,mensaje
    int 21h
    
  endm  

 
;----------------------------------------------------------------------
;      Macro para limpiar un vector luego de escribir
;----------------------------------------------------------------------       
       
  macro limpiarInventario
    mov cx,3
    mov si,0
    vicodigo:
      mov codigo[si],32
      inc si
    loop vicodigo
    mov cx,14
    mov si,0
    vinombre:
      mov nombre[si],32
      inc si
    loop vinombre
    mov cx,2
    mov si,0
    viprecio:
      mov precio[si],32
      inc si
    loop viprecio
    mov cx,3
    mov si,0
    viexistencia:
      mov existencia[si],32
      inc si
    loop viexistencia
  endm 
  
  macro limpiarCompra 
    mov cx,3
    mov si,0
    vccodigo:
      mov codigo[si],32
      inc si
    loop vccodigo
    mov cx,3
    mov si,0
    vccantidad:
      mov cantidad[si],32
      inc si
    loop vccantidad
    mov cx,3
    mov si,0
    vcpago:
      mov pago[si],32
      inc si
    loop vcpago
    mov cx,8
    mov si,0
    vcfecha:
      mov fecha[si],32
      inc si
    loop vcfecha  
     
  endm 
  
  macro limpiarVenta 
    mov cx,3
    mov si,0
    vvcodigo:
      mov codigo[si],32
      inc si
    loop vvcodigo
    mov cx,3
    mov si,0
    vvcantidad:
      mov cantidad[si],32
      inc si
    loop vvcantidad
    mov cx,3
    mov si,0
    vvpago:
      mov pago[si],32
      inc si
    loop vvpago
    mov cx,10
    mov si,0
    vvfecha:
      mov fecha[si],32
      inc si
    loop vvfecha  
     
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
    ;Mensajes de primera vez
    
    
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
    
    ;Mensajes del submenu Compra
    smcVer db "-1-. Ver/Consultar compras",10,13,"$"
    smcIngresar db "-2-. Realizar una compra",10,13,"$"
    smcVolver db "-v-. Volver",10,13,"$"  
    
    ;Mensajes del submenu venta
    smvVer db "-1-. Ver/Consultar ventas",10,13,"$"
    smvIngresar db "-2-. Realizar una venta",10,13,"$"
    smvVolver db "-v-. Volver",10,13,"$"
    
    ;Mensajes de ingreso inventario ii
    iiCodigo db "Ingrese el codigo del producto: ",10,13,"$"
    iiNombre db 10,13,"Ingrese el nombre del producto: ",10,13,"$"
    iiPrecio db 10,13,"Ingrese el precio del producto: ",10,13,"$"
    iiExistencia db 10,13,"Ingrese la existencia del producto ",10,13,"$"
    
    ;Mensajes de ingreso compra ic
    icCantidad db 10,13,"Ingrese la cantidad del producto a comprar: ",10,13,"$"
    icPago db 10,13,"Ingrese el pago dado por el producto: ",10,13,"$"
    icFecha db 10,13,"Ingrese la fecha de compra Ej. 01|01|2001 ",10,13,"$"
    
    ;Mensajes de ingreso compra iv
    ivCantidad db 10,13,"Ingrese la cantidad del producto a vender: ",10,13,"$"
    ivPago db 10,13,"Ingrese el pago dado por el cliente: ",10,13,"$"
    ivFecha db 10,13,"Ingrese la fecha de ventaEj. 01|01|2001 ",10,13,"$" 
                                                                  
    ;Mensajes erorres y varios
    errordeescritura db "Error en la escritura",10,13,"$"
    exito db "Exito en la operacion",10,13,"$"
    exitoInventario db "producto ingresado correctamente.",10,13,"$"
    exitoCompra db "producto comprado correctamente.",10,13,"$"
    exitoVenta db "producto vendido correctamente.",10,13,"$"
    espera db "En proceso, espera un momento...$",10,13,"$"
    grabando db "Grabando en archivo",10,13,"$"
    noExisteProducto db 10,13,"No existe el producto",10,13,"$"
    
    ;Define el directorio, su ruta y los archivos  a
    ainventario db "c:\archivos\inventario.txt",0
    acompra db "c:\archivos\compra.txt",0
    aventa db "c:\archivos\venta.txt",0
    directorio db "c:\archivos",0 
    
    ;Define los texto iniciales de los archivos y su tamaño tia
    tiainventario db "idProducto-nombre-costo-existencia",10,13
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
    separater db "-"
    codigo db 4 dup(" ")
    nombre db 15 dup(" ")
    precio db 3 dup(" ")
    existencia db 3 dup(" ")
    cantidad db 3 dup(" ")
    pago db 3 dup(" ")
    fecha db 10 dup(" ")
    bytesRcod dw 0
    lectura db "$"
    coincidencias dw 0
    
    
    
    
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
        mov ah,10
        consultarInventario
        ;pausa 
        jmp revisarInventario

;======================================================================    
;              Aca se trabajan las compras
;======================================================================    

    realizarCompra: ;Muestra el subMenu Compra
        limpiarPantalla
        subMenuCompra
        pausa
        jmp inicio 
    
    ingresarCompra:
        limpiarPantalla
        ;realizarCompra ;Trabajar en como se ingresa
        ingresarCompra
        pausa
        jmp realizarCompra    
        
    verCompra:
        limpiarPantalla
        lea dx, scompra
        mov ah,9
        int 21h ;muestra el mensaje
        mov ah,10
        ;consultarCompra
        pausa 
        jmp realizarCompra 
    
    noExisteC:
        limpiarPantalla
        imprimir noExisteProducto
        pausa
        jmp realizarCompra
 
;======================================================================    
;              Aca se trabajan las ventas
;======================================================================    

    
    
    realizarVenta: ;Muestra el subMenu Compra
        limpiarPantalla
        subMenuVenta
        pausa
        jmp inicio 
    
    ingresarVenta:
        limpiarPantalla
        ;realizarVenta ;Trabajar en como se ingresa
        ingresarVenta
        pausa
        jmp realizarVenta    
        
    verVenta:
        limpiarPantalla
        lea dx, sventa
        mov ah,9
        int 21h ;muestra el mensaje
        mov ah,10
        ;consultarVenta
        pausa 
        jmp realizarVenta
    noExisteV:
        limpiarPantalla
        imprimir noExisteProducto
        pausa
        jmp realizarVenta


;======================================================================    
;              Se notifica al usuario si hay errore R/W
;======================================================================    
    
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


end start ; set entry point and stop the assembler.



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

;asi grababa al inicio
;mov ah,42h
    ;mov al,02h
    ;mov bx, handle
    ;mov cx,0
    ;mov dx,0
    ;int 21h ;mueve el puntero al final del documento :v 
    ;Sigfrid fue :v          
    ;mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    ;mov cx,si
    ;mov dx, offset vector
    ;mov ah,40h
    ;int 21h   ;Escribe en el archivo la cadena ingresada
    ;mov cx,1
    ;mov dx, offset nuevaLinea
    ;mov ah,40h
    ;int 21h   ;Escribe en el archivo un enter
     
   
 realizarCompra:    ;Aca se realiza una compra
    limpiarPantalla
    lea dx, scompra
    mov ah,9
    int 21h
    realizarCompra
    pausa 
    jmp inicio      
