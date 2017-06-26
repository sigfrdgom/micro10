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



;========================================================================    
;              Aca definimos todas las macros a utilizar
;========================================================================    
                    
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de menu principal
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    
;------------------------------------------------------------------------
;               Macro para mostrar un menu recurrente
;------------------------------------------------------------------------ 
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
;------------------------------------------------------------------------
;               Macro para la seleccion de opciones del menu
;------------------------------------------------------------------------  
  
  macro eleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, 's'
    je salirDeEjecucion
    cmp al,'a'
    je ayudaInicio
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
    limpiarPantalla
    ayudaInicio:
    ayuda
    jmp inicio
  endm  
  
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de submenus
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

;------------------------------------------------------------------------
;               Macro para el submenu inventario
;------------------------------------------------------------------------  
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

;------------------------------------------------------------------------
;               Macro para el submenu compra
;------------------------------------------------------------------------  
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
  
;------------------------------------------------------------------------
;               Macro para el submenu venta
;------------------------------------------------------------------------  
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de consultas
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  
;------------------------------------------------------------------------
;               Macro para consultar el contenido de inventario
;------------------------------------------------------------------------  
  macro consultarInventario
  
        mov al,2
        mov dx, offset ainventario
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
         
;lee la tupla entera[1234-abcdefghijklmnopqrst-100-120@]              
                   ;[0123456789012345678901234567890123]
            leerInvCon:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;            
               cmp ax,0               
               jz salidaInvCon               
               mov lectura[34],13
               mov lectura[35],"$"
               imprimir lectura
               jne leerInvCon
 
         salidaInvCon:
        
  endm

;------------------------------------------------------------------------
;               Macro para consultar el contenido de compra
;------------------------------------------------------------------------  
  macro consultarCompra
      mov al,2
        mov dx, offset acompra
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
         
;lee la tupla entera[1234-999-9999-01|01|2002@]              
                   ;[0123456789012345678901234]
            leerComCon:
               mov bx, handle
               mov cx,24
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;            
               cmp ax,0               
               jz salidaComCon
               mov lectura[24],10               
               mov lectura[25],13
               mov lectura[26],"$"
               imprimir lectura
               jne leerComCon
 
         salidaComCon:         
  endm
 
 
;------------------------------------------------------------------------
;               Macro para consultar el contenido de venta
;------------------------------------------------------------------------  
  macro consultarVenta
                mov al,2
        mov dx, offset acompra
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
         
;lee la tupla entera[1234-999-9999-01|01|2002@]              
                   ;[0123456789012345678901234]
            leerVenCon:
               mov bx, handle
               mov cx,24
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;            
               cmp ax,0               
               jz salidaVenCon
               mov lectura[24],10               
               mov lectura[25],13
               mov lectura[26],"$"
               imprimir lectura
               jne leerVenCon
 
         salidaVenCon:        
  endm

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de ingreso y escritura
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

;------------------------------------------------------------------------
;       Para escribir algo en el archivo inventario.   
;------------------------------------------------------------------------  

 macro ingresarInventario  
    limpiarInventario ;Peligroso cuidado al usar
    
    imprimir iiCodigo
    mov cx,4
    
        pedirCodigoInventario:
        mov ah,1
        int 21h
        cmp al,13
        je okCodigo:
        mov dl, codigo[1]
        mov codigo[0],dl
        mov dl, codigo[2]
        mov codigo[1],dl
        mov dl, codigo[3]
        mov codigo[2],dl
        mov codigo[3],al
       
        loop pedirCodigoInventario
    
    okCodigo:
    aprobarProducto codigo;aca valida si existe o no si existe continua
    
    imprimir iiNombre
    mov cx,20
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
        
        mov dl, existencia[1]
        mov existencia[0],dl
        mov dl, existencia[2]
        mov existencia[1],dl
        mov existencia[2],al     

        loop pedirExistenciaInventario
    
    okExistencia:
    
    escribirInventario codigo nombre precio existencia
  
    
 endm   
     
;----------------------------------------------------------------------
;   Para escribir [ingresarInventario] en el archivo inventario
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
    mov cx,20
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
    int 21h ;cierra el archivo;Funciona de buena manera
 endm 
  
;----------------------------------------------------------------------
;Para escribir algo en el archivo compra, validando que exista codigo   
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
        
            mov dl, codigo[1]
            mov codigo[0],dl
            mov dl, codigo[2]
            mov codigo[1],dl
            mov dl, codigo[3]
            mov codigo[2],dl
            mov codigo[3],al
        loop pedirCodigoCompra
    okCodigoC:
    realizarCompra codigo;aca valida codigo ;si pasa continua en realizar compra 
    
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
    mov cx,4
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
;     Para ingresar algo en el archivo venta, validando que exista   
;----------------------------------------------------------------------  

 macro ingresarVenta  
    
    limpiarVenta ;Peligroso cuidado al usar
    
    imprimir iiCodigo
    mov cx,4
    mov si,0
        pedirCodigoV:
        mov ah,1
        int 21h
        cmp al,13
        je okCodigoV:        
            mov dl, codigo[1]
            mov codigo[0],dl
            mov dl, codigo[2]
            mov codigo[1],dl
            mov dl, codigo[3]
            mov codigo[2],dl
            mov codigo[3],al
        loop pedirCodigoV
    
    okCodigoV:
    realizarVenta codigo;aca valida codigo ;si pasa continua en realizar compra 
    
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
    mov cx,4
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
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
        mov bytesRcod,0 
;lee la tupla entera[1234-abcdefghijklmnopqrst-100-120@]              
                   ;[0123456789012345678901234567890123]
            leerInvC:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;            
               cmp ax,0               
               jz salidaC               
               mov dl,codigo[0]
               cmp lectura[0],dl
               jne leerInvC
               mov dl,codigo[1]
               cmp lectura[1],dl
               jne leerInvC
               mov dl,codigo[2]
               cmp lectura[2],dl
               jne leerInvC
               mov dl,codigo[3]
               cmp lectura[3],dl
               jne leerInvC
  
          mov coincidencias,1     
          cmp coincidencias,1
          je salidaC                          
        ;si no existe coincidencia
          mov dx, offset ainventario
          mov ah, 3eh
          int 21h ;cierra archivo 
        jmp noExisteC ;se va al carajeux     
          
     salidaC:;mueve a cantidad actual el codigo
    mov al,lectura[30]
    mov cantidadActual[0],al
    mov al,lectura[31]
    mov cantidadActual[1],al
    mov al,lectura[32]
    mov cantidadActual[2],al
    ;ok toma la existencia actual
    
    imprimir icCantidad
    mov cx,3
    mov si,0
        pedirCantidadC:
        mov ah,1
        int 21h
        cmp al,13
        je okCantidadC:
        mov dl, cantidad[1]
        mov cantidad[0],dl
        mov nuevaCantidad[1],dl
        
        mov dl, cantidad[2]
        mov cantidad[1],dl
        mov nuevaCantidad[1],dl
        
        mov cantidad[2],al
        mov nuevaCantidad[2],al
        loop pedirCantidadC
    
    okCantidadC:
    
    imprimir icPago
    mov cx,4
    mov si,0
        pedirPagoC:
        mov ah,1
        int 21h
        cmp al,13
        je okPagoC:
        mov pago[si],al   ;pide monto de pago
        inc si
        loop pedirPagoC
    
    okPagoC:
    imprimir icFecha
    mov cx,10
    mov si,0
        pedirFechaC:
        mov ah,1
        int 21h
        mov fecha[si],al  ;pide fecha en formato 12|12|2012
        inc si
        loop pedirFechaC 
                   ;sumarCantidad cantidadActual cantidad 
       escribirCompra codigo cantidad pago fecha ;escribe los datos en compra.txt
       
       mov ax,0
       mov bx,0
       mov cx,0
       mov al,cantidadActual[0]
       sub ax,48
       mov bx,10
       mul bx
       mov cl,cantidadActual[1]
       sub cx,48
       add ax,cx
       mov bx,10
       mul bx
       mov cl,cantidadActual[2]
       sub cx,48
       add ax,cx   ;ok
       mov uno,ax
       mov ax,0
       mov bx,0
       mov cx,0 
       mov al,cantidad[0]
       sub ax,48
       mov bx,10
       mul bx
       mov cl, cantidad[1]
       sub cx,48
       add ax,cx
       mov bx,10
       mul bx
       mov cl, cantidad[2]
       sub cx,48
       add ax,cx   ;ok
       mov dos,ax                       
       mov cx, uno
       mov bx, dos
       add cx,bx 
       mov tres, cx
       cmp tres,999
       jae noSePuede:
       mov ax,0
       mov bx,0                                             
       mov ax,tres ;aca empieza la suma final
       mov bl,10
       div bl ;Residuo ah,Cociente al
       add ah,48 
       mov cantidad[2], ah ;6 en 2
       mov cx,ax
       mov ch,00
       mov ax,cx
       mov bl,10
       div bl 
       add ah,48
       mov cantidad[1], ah  ;4 en 1
       mov cx,ax
       mov ch,00
       mov ax, cx
       mov bl, 10
       div bl
       add ah,48
       mov cantidad[0], ah ;2 en 0
       jmp finSumar:
       noSePuede:
       imprimir overStock
       pausa 
       jmp realizarCompra
        
       finSumar: ;ok hora se escribir :v OK                      
        mov coincidencias,0
        mov al,2
        mov dx, offset ainventario
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0
        mov bytesRcod,0 
        
            leerInvC1:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;lee tupla entera[1234-abcdefghijklmnopqrst-100-120@]              
               cmp ax,0                ;[0123456789012345678901234567890123]
               jz salidaC1               
               mov dl,codigo[0]
               cmp lectura[0],dl
               jne leerInvC1
               mov dl,codigo[1]
               cmp lectura[1],dl
               jne leerInvC1
               mov dl,codigo[2]
               cmp lectura[2],dl
               jne leerInvC1
               mov dl,codigo[3]
               cmp lectura[3],dl
               jne leerInvC1
          mov coincidencias,1     
          cmp coincidencias,1
          je salidaC1          ;vuele a buscar la tupla para estar seguros                              
                       
    salidaC1:                                                 
    mov ah,42h
    mov al,01h
    mov cx,0
    mov dx,-4
    int 21h ;mueve el puntero al ultimo bloque
     
    mov cx,3
    mov dx, offset cantidad
    mov ah,40h
    int 21h   ;Escribe en el archivo la nueva existencia :v     
     
    mov ah,42h
    mov al,01h
    mov cx,0
    mov dx,2 ;devuelve a donde estaba despues de escribir
    int 21h    
    
    okFechaC:
          
  endm   
  
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de ventas
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
;----------------------------------------------------------------------
;      Macro de aprobacion para realizar una venta
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
;lee la tupla entera[1234-abcdefghijklmnopqrst-100-120@]              
                   ;[0123456789012345678901234567890123]
            leerInvV:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;            
               cmp ax,0               
               jz salidaV               
               mov dl,codigo[0]
               cmp lectura[0],dl
               jne leerInvV
               mov dl,codigo[1]
               cmp lectura[1],dl
               jne leerInvV
               mov dl,codigo[2]
               cmp lectura[2],dl
               jne leerInvV
               mov dl,codigo[3]
               cmp lectura[3],dl
               jne leerInvV
  
          mov coincidencias,1     
          cmp coincidencias,1
          je salidaV                          
        ;si no existe coincidencia
          mov dx, offset ainventario
          mov ah, 3eh
          int 21h ;cierra archivo 
        jmp noExisteV ;se va al carajeux     
          
     salidaV:;mueve a cantidad actual el codigo
    mov al,lectura[30]
    mov cantidadActual[0],al
    mov al,lectura[31]
    mov cantidadActual[1],al
    mov al,lectura[32]
    mov cantidadActual[2],al
    ;ok toma la existencia actual
    
    imprimir ivCantidad
    mov cx,3
    mov si,0
        pedirCantidadV:
        mov ah,1
        int 21h
        cmp al,13
        je okCantidadV:
        mov dl, cantidad[1]
        mov cantidad[0],dl 
        mov nuevaCantidad[0],dl
        mov dl, cantidad[2]
        mov cantidad[1],dl
        mov nuevaCantidad[1],dl
        mov cantidad[2],al 
        mov nuevaCantidad[2],al
        loop pedirCantidadV
    
    okCantidadV:
    imprimir ivPago
    mov cx,4
    mov si,0
        pedirPagoV:
        mov ah,1
        int 21h
        cmp al,13
        je okPagoV:
        mov pago[si],al   ;pide monto de pago
        inc si
        loop pedirPagoV
    
    okPagoV:
    imprimir ivFecha
    mov cx,10
    mov si,0
        pedirFechaV:
        mov ah,1
        int 21h
        mov fecha[si],al  ;pide fecha en formato 12|12|2012
        inc si
        loop pedirFechaV 
                   ;resta Cantidad + cantidadActual= cantidad  uno-dos
                   
       escribirVenta codigo cantidad pago fecha ;escribe los datos en compra.txt 
       mov ax,0
       mov bx,0
       mov cx,0
       mov al,cantidadActual[0]
       sub ax,48
       mov bx,10
       mul bx
       mov cl,cantidadActual[1]
       sub cx,48
       add ax,cx
       mov bx,10
       mul bx
       mov cl,cantidadActual[2]
       sub cx,48
       add ax,cx   ;ok
       mov uno,ax
       
       mov ax,0
       mov bx,0
       mov cx,0
       mov al,cantidad[0]
       sub ax,48
       mov bx,10
       mul bx
       mov cl, cantidad[1]
       sub cx,48
       add ax,cx
       mov bx,10
       mul bx
       mov cl, cantidad[2]
       sub cx,48
       add ax,cx   ;ok
       mov dos,ax                      
       mov cx, uno
       mov bx, dos
       sub cx,bx 
       mov tres, cx
       cmp tres,0
       jbe noSePuedeV: 
       mov ax,0
       mov bx,0                                             
       mov ax,tres ;aca empieza la resta final
       mov bl,10
       div bl ;Residuo ah,Cociente al
       add ah,48 
       mov cantidad[2], ah ;6 en 2
       mov cx,ax
       mov ch,00
       mov ax,cx
       mov bl,10
       div bl 
       add ah,48
       mov cantidad[1], ah  ;4 en 1
       mov cx,ax
       mov ch,00
       mov ax, cx
       mov bl, 10
       div bl
       add ah,48
       mov cantidad[0], ah ;2 en 0
       jmp finRestarV:

       noSePuedeV:
       imprimir overStock
       pausa 
       jmp realizarCompra
        
       finRestarV: ;ok hora se escribir :v OK                      
        mov coincidencias,0
        mov al,2
        mov dx, offset ainventario
        mov ah, 3dh
        int 21h     ;abre archivo
        mov handle,ax        
        mov si,0        
            leerInvV1:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h ;lee tupla entera[1234-abcdefghijklmnopqrst-100-120@]              
               cmp ax,0                ;[0123456789012345678901234567890123]
               jz salidaV1               
               mov dl,codigo[0]
               cmp lectura[0],dl
               jne leerInvV1
               mov dl,codigo[1]
               cmp lectura[1],dl
               jne leerInvV1
               mov dl,codigo[2]
               cmp lectura[2],dl
               jne leerInvV1
               mov dl,codigo[3]
               cmp lectura[3],dl
               jne leerInvV1
          mov coincidencias,1     
          cmp coincidencias,1
          je salidaV1          ;vuele a buscar la tupla para estar seguros                            
                       
    salidaV1:                                                 
    mov ah,42h
    mov al,01h
    mov cx,0
    mov dx,-4
    int 21h ;mueve el puntero al ultimo bloque  
    mov cx,3
    mov dx, offset cantidad
    mov ah,40h
    int 21h   ;Escribe en el archivo la nueva existencia :v                                              
    mov ah,42h
    mov al,01h
    mov cx,0
    mov dx,2 ;devuelve a donde estaba despues de escribir
    int 21h    
    
    okFechaV:
    
                       
  endm                            
                        
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;           seccion de utilitarias
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                                                                                
;----------------------------------------------------------------------
;      Macro de aprobacion para realizar una compra
;----------------------------------------------------------------------       
       
  macro aprobarProducto codigo
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
            leerInv:
               mov bx, handle
               mov cx,34
               mov dx, offset lectura
               mov ah, 3fh
               int 21h               
               cmp ax,0
               jz salida               
               mov dl,codigo[0]
               cmp lectura[0],dl
               jne leerInv
               mov dl,codigo[1]
               cmp lectura[1],dl
               jne leerInv
               mov dl,codigo[2]
               cmp lectura[2],dl
               jne leerInv
               mov dl,codigo[3]
               cmp lectura[3],dl
               jne leerInv
          mov coincidencias,1     
          mov dx, offset ainventario
          mov ah, 3eh
          int 21h   ;cierra archivo
          cmp coincidencias,1
          je yaExisteProducto 
      salida:                                   
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
;      Macro para limpiar un vector luego de escribir inventario
;----------------------------------------------------------------------       
       
  macro limpiarInventario
    mov codigo[0],48
    mov codigo[1],48
    mov codigo[2],48
    mov codigo[3],48
    mov cx,16
    mov si,0
    vinombre:
      mov nombre[si],32
      inc si
    loop vinombre
     mov precio[0],32
     mov precio[1],32
     mov precio[2],32
     mov precio[3],32  
     mov existencia[0],48
     mov existencia[1],48
     mov existencia[2],48
  endm   
  
;----------------------------------------------------------------------
;      Macro para limpiar un vector luego de escribir  compra
;----------------------------------------------------------------------  
  
  macro limpiarCompra
    mov uno,0000h
    mov dos,0000h
    mov tres,0000h
    mov cantidadActual[0],48
    mov cantidadActual[1],48
    mov cantidadActual[2],48
    mov nuevaCantidad[0],48
    mov nuevaCantidad[1],48
    mov nuevaCantidad[2],48     
    mov Cantidad[0],48
    mov Cantidad[1],48
    mov Cantidad[2],48           
    mov codigo[0],48
    mov codigo[1],48
    mov codigo[2],48
    mov codigo[3],48         
    mov cx,3
    mov si,0
    vcpago:
      mov pago[si],32
      inc si
    loop vcpago                 
    mov cx,10
    mov si,0
    vcfecha:
      mov fecha[si],32
      inc si
    loop vcfecha                 
  endm  
  
;----------------------------------------------------------------------
;      Macro para limpiar un vector luego de escribir  venta
;----------------------------------------------------------------------  
  
  macro limpiarVenta
    mov uno,0000h
    mov dos,0000h
    mov tres,0000h 
    mov codigo[0],48
    mov codigo[1],48
    mov codigo[2],48
    mov codigo[3],48 
    mov Cantidad[0],48
    mov Cantidad[1],48
    mov Cantidad[2],48
    mov cantidadActual[0],48
    mov cantidadActual[1],48
    mov cantidadActual[2],48
    mov nuevaCantidad[0],48
    mov nuevaCantidad[1],48
    mov nuevaCantidad[2],48
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
;       macro de ayuda
;---------------------------------------------------------------------- 
 
 macro ayuda
    limpiarPantalla
    imprimir mayuda
    imprimir mayuda1
    imprimir mayuda2
    imprimir mayuda3
    imprimir mayuda4
    imprimir mayuda5
    imprimir mayuda6
    imprimir mayuda7
    imprimir mayuda8
    imprimir mayuda9
    imprimir mayuda10
    pausa
    jmp inicio 
    endm
 
;----------------------------------------------------------------------
;       Fin de las macros :v
;----------------------------------------------------------------------

     
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@          
;#####################################################################
;      Aca inicia el programa en si
;#####################################################################
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         
                                                                      
                                                                      
;*********************************************************************
;    Aca se declaran las variables a utilizar
;*********************************************************************
data segment 
    ;Mensajes de primera bienvenida
     bienvenido db "Bienvenido seas al sistemas de inventario",10,13,"$"
     bienvenido1 db "Si es primera vez usa presiona 0",10,13,"$"
     bienvenido2 db "Si no lo es, presion cualquier otra tecla",10,13,"$"
     sigfrid db "GG13008 GÛmez Guinea, Sigfrido Ernesto ",10,13,"$"
     pacheco db "PC10010 Pacheco Calderon, Edwin Omar   ",10,13,"$"
     disponible db "github.com/sigfrdgom/micro10",10,13,"$"
     bienvenido3 db "Disfruta de tu producto",10,13,"$"
     
     
     ;mensajes de ayuda
     mayuda db "Bienvenido a la ayuda..",10,13,"$"
     mayuda1 db "Recuerda ingresar la fecha usando pipe",10,13,"$"
     mayuda2 db "Recuerda tambien que esto no es una version final",10,13,"$"
     mayuda3 db "Se cuidadoso al usarla y respeta los formatos",10,13,"$"
     mayuda4 db "las longitudes son:",10,13,"$"
     mayuda5 db "Codigo 4 digitos; ",10,13,"$"
     mayuda6 db "Precio, existencia, cantidad 3 digitos; ",10,13,"$"
     mayuda7 db "El maximo stock es 999 y el minimo 1; ",10,13,"$"
     mayuda8 db "Operaciones monetarias maximas de 9999; ",10,13,"$"
     mayuda9 db "Nombres de productos alfa-numericos aceptados",10,13,"$"
     mayuda10 db "Disfruta de tu programa :v ",10,13,"$"
     
    
    ;Mensajes del menu m
    msalir db "presiona s para salir...",10,13,"$"
    mseleccione db "Presione el numero de lo que desea hacer:",10,13,"$"                 
    mprimeravez db "-A-. Para desplegar la ayuda!",10,13,"$"
    minventario db "-1-. Gestion Inventario",10,13,"$"
    mcompra db "-2-. Gestion Compra",10,13,"$"
    mventa db  "-3-. Gestion Venta",10,13,"$"
    mSalidaDeEjecucion db "gracias por usarme, presiona una tecla para salir",10,13,"$"
    
    ;Mensajes de las opciones selecionadas s 
    sprimeravez db "Felicidades, se han creado sus archivos de gestion",10,13,"$"
    sinventario db "Codigo-nombre---------precio-cantidad",10,13,"$"
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
    iiCodigo db "Ingrese el codigo del producto que sea de 4 digitos: ",10,13,"$"
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
    exitoInventario db "Producto ingresado correctamente.",10,13,"$"
    exitoCompra db "Producto comprado correctamente.",10,13,"$"
    exitoVenta db "Producto vendido correctamente.",10,13,"$"
    espera db "En proceso, espera un momento...$",10,13,"$"
    grabando db "Grabando en archivo....",10,13,"$"
    noExisteProducto db 10,13,"Error, el producto que ud ingreso no existe...",10,13,"$" 
    yaExisteP db 10,13,"Eror, el producto que ud marco ya existe...",10,13,"$"
    
    ;Define el directorio, su ruta y los archivos  a
    ainventario db "c:\archivos\inventario.txt",0
    acompra db "c:\archivos\compra.txt",0
    aventa db "c:\archivos\venta.txt",0
    directorio db "c:\archivos",0 
    
    ;Define los texto iniciales de los archivos y su tama√±o tia
    tiainventario db "idProducto-nombre-costo-existencia",10,13
    tiainventario_tam = $ - offset tiainventario
    tiacompra db "   codProducto-cantidad-pago-fecha",10,13
    tiacompra_tam = $ - offset tiacompra
    tiaventa db  "   codProducto-cantidad-pago-fecha",10,13
    tiaventa_tam = $ - offset tiaventa 
    noDisponible db "Lo sentimos la funcion no esta disponible en la v1.0",10,13,"$"
   
    ;Lineas para saltos y vectores de ingreso
    vecInventario db 255 dup("$")
    nuevaLinea db 10,13
    
    ;El elemento magico
    handle dw 0
    handle1 dw 0
    
    ;variables utilitarias
    separater db "-"
    codigo db 4 dup(" ")
    nombre db 20 dup(" ")
    precio db 3 dup(" ")
    existencia db 3 dup(" ")
    cantidad db 3 dup(" ")
    pago db 4 dup(" ")
    fecha db 10 dup(" ")
    bytesRcod dw 0
    lectura db "$"
    coincidencias dw 0
    
    cantidadActual db 3 dup(" ")
    nuevaCantidad db 3 dup(" ") 
    acarreo db 0 
    contador db 0
    overStock db "No se procesa, sobrepasa el stock maximo",10,13,"$" 
    
    uno dw 0000
    dos dw 0000
    tres dw 0000
    
    
    
    
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
    
    virgen:
    lea dx,bienvenido
    mov ah,9
    int 21h
    lea dx,bienvenido1
    mov ah,9
    int 21h
    lea dx,bienvenido2
    mov ah,9
    int 21h
    lea dx,bienvenido3
    mov ah,9
    int 21h 
    imprimir sigfrid
    imprimir pacheco
    imprimir disponible
    ;aca para las opciones de seleccion
    mov ax,0000
    mov ah,1
    int 21h
    cmp al, '0'
    je primeravez
    jmp inicio
    
          
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
        pausa 
        jmp revisarInventario
        
    yaExisteProducto:
        limpiarPantalla
        imprimir yaExisteP
        pausa
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
        imprimir noDisponible
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
        imprimir noDisponible
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
