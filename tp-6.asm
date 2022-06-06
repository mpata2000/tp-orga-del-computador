; Se tienen n objetos de pesos P1, P2, ..., Pn (con n <= 20) que deben ser enviados por correo a una
; misma dirección. La forma más simple sería ponerlos todos en un mismo paquete; sin embargo, el
; correo no acepta que los paquetes tengan más de 11 Kg. y la suma de los pesos podría ser mayor
; que eso. Afortunadamente, cada uno de los objetos no pesa más de 11 Kg.
;
; Se trata entonces de pensar un algoritmo que de un método para armar los paquetes, tratando de
; optimizar su cantidad. Debe escribir un programa en assembler Intel 80x86 que:
;
; ● Permita la entrada de un entero positivo n.
; ● La entrada de los n pesos, verificando que 0<Pi<=11 donde i <=n.
; ● Los Pi pueden ser valores enteros.
; ● Exhiba en pantalla la forma en que los objetos deben ser dispuestos en los paquetes.
;
; A su vez existen tres destinos posibles: Mar del Plata, Bariloche y Posadas. El correo por normas
; internas de funcionamiento no puede poner en el mismo paquete objetos que vayan a distinto destino.
; Desarrollar un algoritmo que proporcione una forma de acomodar los paquetes de forma que no haya
; objetos de distinto destino en un mismo paquete y cumpliendo las restricciones de peso. Se sugiere
; tener una salida como la siguiente:
; • Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)
; • Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)
; • Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)

global main
extern printf
extern puts
extern gets
extern sscanf

section     .data
    mensaje_ingresar_destino    db "Ingrese el destino:",0
    mensaje_destino_invalido    db "El destino no es valido. Los posibles destinos son Mar del Plata(M), Bariloche(B) y Posadas(P). Intente nuevamente:",0
    formato_destino             db "%c"
    mensaje_ingresar_peso       db "Ingrese un numero etre el 1 y 11 inclusive",0
    mensaje_peso_invalido       db "El peso ingresado es invalido. El peso debe estar entre 0 y 11 inclusive(0<p<=11). Intente nuevamente:",0
    formato_peso                db "%i"
    mensaje1                    db "Numero: %lli",10,0

section     .bss
    input    resb   500    
    destino  resb   1
    peso     resd   1

section     .text
main:
    mov rcx,mensaje_ingresar_destino
    sub rsp,32
    call puts
    add rsp,32
ingresarDestino:
    mov rcx,input
    sub rsp,32
    call gets
    add rsp,32

    ;paso primer caracter a destino
    mov ah,[input]
    mov byte[destino],ah

    ;mov rcx,input
    ;mov rdx,formato_destino
    ;mov r8,destino
    ;sub rsp,32
    ;call sscanf
    ;add rsp,32
    

    call validarDestino
    cmp rax,0
    je ingresarDestino ;Si el destino no es valido se lo vuelve a pedir
    
    mov rcx,mensaje_ingresar_peso
    sub rsp,32
    call puts
    add rsp,32

ingresoPeso:
    mov rcx,input
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,input
    mov rdx,formato_peso
    mov r8,peso
    sub rsp,32
    call sscanf
    add rsp,32

    call validarPeso
    cmp rax,0
    je ingresoPeso

    mov rcx,mensaje1
    mov rdx,[peso]
    sub rsp,32
    call printf
    add rsp,32

finPrograma:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;             VALIDAR DESTINO                ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validarDestino:
    ;Destinos: Mar del Plata(M), Bariloche(B) y Posadas(P), 
    mov rax,0
    cmp byte[destino],"M"
    je destinoValido
    cmp byte[destino],"B"
    je destinoValido
    cmp byte[destino],"P"
    je destinoValido

    ;Destino no es valido
    mov rcx,mensaje_destino_invalido
    sub rsp,32
    call puts
    add rsp,32
    ret
destinoValido:
    mov rax,1
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;               VALIDAR PESO                 ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validarPeso:
    ;verificando que 0<Pi<=11, devuelve rax=1 valido o rax=0 si es invalido
    mov rax,1
    cmp dword[peso],0
    jle pesoInvalido ;Si es menor igual a 0 es invalido
    cmp dword[peso],11
    jg pesoInvalido
    ret
pesoInvalido:
    ;Peso no es valido
    mov rcx,mensaje_peso_invalido
    sub rsp,32
    call puts
    add rsp,32
    mov rax,0
    ret



