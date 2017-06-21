; multi-segment executable file template.
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
  
  macro limpiarPantalla
    MOV AX,0600H ; Peticion para limpiar pantalla
    MOV BH,0F0H  ;pantalla blaca{0F}, letra negra{0}
    MOV CX,0000H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,184FH ; Cursor al final de la pantalla Ren=24(18) 
    INT 10H 
    MOV AH,02H 
    MOV BH,00 
    MOV DH,0 
    MOV DL,0 
    INT 10H 
  endm  
  
  macro primeravezarchivos
    mov dx, offset directorio
    mov ah, 39h
    int 21h
    ;aca se crean y escribe en los archivos
    ;archivo inventario
    mov ah, 3ch
    mov cx, 0
    mov dx, offset ainventario
    int 21h
    jc err
    mov handle, ax
    ; write to file:
    ;mov ah, 40h
    ;mov bx, handle
    ;mov dx, offset tiainventario
    ;mov cx, tiainventario_tam
    ;int 21h
    ; close c:\emu8086\vdrive\C\archivo\inventario.txt
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
    ; write to file:
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
    ; write to file:
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
  
  macro pausa
    lea dx, spausa
    mov ah,9
    int 21h
    mov ah,1
    int 21h
    
    endm
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
    okInv:
    escribirInventario vecInventario   
 endm   
     ;no guarda el vector escrito en el archivo
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
    int 21h ;mueve el puntero al final del codumento
              
    mov bx,handle ;mueve a bx el handle  usar handle en lugar de ax
    mov cx,si
    mov dx, offset vector
    mov ah,40h
    int 21h   ;Escribe en el archivo la cadena ingresada
    ;;;;;;;;;;;;;;,,
    mov cx,1
    mov dx, offset nuevaLinea
    mov ah,40h
    int 21h   ;Escribe en el archivo un enter
    
   ;;;;;;;;;ACA TERMINA 
    limpiarPantalla
    lea dx, exito
    mov ah,9
    int 21h
    mov ah, 3eh
    int 21h  ;cierra archivo
    endm
         
         
data segment
    msalir db "presiona s para salir...",10,13,"$"
    mseleccione db "Presione el numero de lo que desea hacer:",10,13,"$"                 
    mprimeravez db "0. Si es primera vez, si no esta seguro que es primera vez, no lo use!",10,13,"$"
    minventario db "1. Gestion Inventario",10,13,"$"
    mcompra db "2. Gestion Compra",10,13,"$"
    mventa db  "3. Gestion Venta",10,13,"$"
    mSalidaDeEjecucion db "gracias por usarme, presiona una tecla para salir",10,13,"$"
    sprimeravez db "Felicidades, se han creado sus archivos de gestion",10,13,"$"
    sinventario db "Esta viendo el inventario",10,13,"$"
    scompra db "Esta Realizando una compra",10,13,"$"
    sventa db  "Esta realizanco una venta",10,13,"$"
    serrorseleccion db "Opcion no encontrada, intente de nuevo",10,13,"$"
    spausa db "Presione cualquier tecla para reanudar",10,13,"$"
    ;mensajes erorres y varios
    errordeescritura db "Error en la escritura",10,13,"$"
    exito db "Exito en la operacion",10,13,"$"
    
    ;Define el directorio, su ruta y los archivos
    ainventario db "c:\archivos\inventario.txt",0
    acompra db "c:\archivos\compra.txt",0
    aventa db "c:\archivos\venta.txt",0
    directorio db "c:\archivos",0
    ;Define lso texto iniciales de los archivos y su tamaño
    tiainventario db "codProducto             nombre                  costo           existencia" 
    tiainventario_tam = $ - offset tiainventario
    tiacompra db "codProducto             pago            fecha"
    tiacompra_tam = $ - offset tiacompra
    tiaventa db  "codProducto             cantidad                pago            fecha"
    tiaventa_tam = $ - offset tiaventa
    ;prueba
    ;textodeprueba db "1234      Botella     $1.00       10"
    tam_textodeprueba = $ -offset textodeprueba
    
    vecInventario db 255 dup("$")
    nuevaLinea db 10,13
    ;El elemento magico
    handle dw 0
    handle1 dw 0
    
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
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
   
    primeravez: ;crearia los archivos si es primera vez 
    limpiarPantalla
    primeravezarchivos;Crea los archivos a usarse si es primera vez
    lea dx, sprimeravez
    mov ah,9
    int 21h 
    pausa
    jmp inicio:
    
    
    
    revisarInventario: ;Mostraria el inventario
    limpiarPantalla
    ingresarInventario
    ;escribirInventario
    ;obtenga la linea y concatene
    
    lea dx, sinventario
    mov ah,9
    int 21h
    pausa 
    ;prueba de escritura
    ;aca termina
    jmp inicio
    
    realizarCompra:    ;Aca se realiza una compra
    limpiarPantalla
    lea dx, scompra
    mov ah,9
    int 21h
    pausa
    jmp inicio    
    
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