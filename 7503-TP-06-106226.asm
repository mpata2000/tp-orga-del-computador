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
    mensaje_ingresar_objetos        db ",-----------------------------------------------------------,",10,
                                    db "| Ingrese la cantidad de objetos que quiere enviar          |",10,
                                    db "| Puede enviar de 1 a 20 objetos (0<n<=20)                  |",10,
                                    db "'-----------------------------------------------------------'",10,
                                    db "Input: ",0
    mensaje_objetos_invalido        db "La cantidad de objetos no es valida. Se pueden enviar de 1 a 20 objetos (0<n<=20)",10,
                                    db "Intente nuevamente: ",0
    mensaje_ingresar_destino        db ",--------------------------------------------------------------,",10,
                                    db "| Ingrese el destino del objeto %2i. Los posibles destinos son: |",10,
                                    db "|  > [M] Mar del Plata                                         |",10,
                                    db "|  > [B] Bariloche                                             |",10,
                                    db "|  > [P] Posadas                                               |",10,
                                    db "'--------------------------------------------------------------'",10,
                                    db "Input: ",0
    mensaje_destino_invalido        db "El destino no es valido. Los posibles destinos son:",10,
                                    db " > [M] Mar del Plata                               ",10,
                                    db " > [B] Bariloche                                   ",10,
                                    db " > [P] Posadas                                     ",10,
                                    db "Intente nuevamente: ",0
    mensaje_ingresar_peso           db ",-----------------------------------------------------------,",10,
                                    db "| Ingrese el peso del objeto %2i con destino a [%c]           |",10,
                                    db "| El peso deberia estar entre el 1 y 11 inclusive (0<p<=11) |",10,
                                    db "'-----------------------------------------------------------'",10,
                                    db "Input: ",0
    mensaje_peso_invalido           db "El peso ingresado es invalido. El peso debe estar entre 0 y 11 inclusive(0<p<=11).",10,
                                    db "Intente nuevamente: ",0
    formato_numero                  db "%i",0
    test_numero                  db " Ind : %i ",10,0
    mensaje_primer_numero           db "%i",0
    mensaje_numero                  db " - %i",0
    mensaje_salto_linea             db "",10,0
    mensaje_final                   db "Los siguientes paquetes seran enviados a sus correspondientes destinos:",0
    formato_destino                 db 10,"Paquete [%i] destino %s: ",0
    formato_TEST_1                 db "PESO BUSCADO [%i]",10,0
    formato_TEST_2                 db "SE AGREGA PESO EN POSICION [%i]",10,0
    formato_TEST_3                 db "PESO ACTUAL [%i]",10,0
    formato_TEST_4                 db "INDICE [%i]",10,0
    formato_TEST_5                 db "Peso %i en %lli",10,0
    ;Vectores Destino
    mensaje_mdq                     db "Mar del Plata",0
    vector_mdq       times 20       dd 0
    posiscion_mdq                   dq 0
    mensaje_bar                     db "Bariloche",0
    vector_bar       times 20       dd 0
    posiscion_bar                   dq 0
    mensaje_pos                     db "Posadas",0
    vector_pos       times 20       dd 0
    posiscion_pos                   dq 0
    vector_imprimir  times 20       dd 0
    posicion_imprimir               dq 0
    ;Contadores
    contador_objetos                dd 0
    contador_peso                   dd 0
    contador_paquetes               dd 0

section     .bss
    input                   resb   500   
    output                  resb   100
    indice                  resq   1
    tamaño                  resq   1
    destino                 resb   1
    peso                    resd   1
    peso_buscado            resd   1
    cantidad_objetos        resd   1

section     .text
main:
    mov rcx,mensaje_ingresar_objetos
    sub rsp,32
    call printf
    add rsp,32
ingresarObjetos:
    mov rcx,input
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,input
    mov rdx,formato_numero
    mov r8,cantidad_objetos
    sub rsp,32
    call sscanf
    add rsp,32

    call validarObjetos
    cmp rax,0
    je ingresarObjetos


mensajeIngresarDestino:
    inc dword[contador_objetos]
    mov rcx,mensaje_ingresar_destino
    mov rdx,[contador_objetos]
    sub rsp,32
    call printf
    add rsp,32


ingresarDestino:
    mov byte[destino],0
    mov byte[input],0
    mov rcx,input
    sub rsp,32
    call gets
    add rsp,32

    ;paso primer caracter a destino
    mov ah,[input]
    mov byte[destino],ah

    sub rsp,32
    call validarDestino
    add rsp,32
    cmp rax,0
    je ingresarDestino ;Si el destino no es valido se lo vuelve a pedir

ingresoPesoMensaje:
    mov rcx,mensaje_ingresar_peso
    mov rdx,[contador_objetos]
    mov r8,[destino]
    sub rsp,32
    call printf
    add rsp,32

    call ingresarPeso

    call agregarPaqueteADestino
    
    mov eax,[cantidad_objetos]
    cmp dword[contador_objetos],eax
    jl mensajeIngresarDestino

    call clearScreen

    mov rcx,mensaje_final
    sub rsp,32
    call puts
    add rsp,32
    ; Imprimo lo del destino Mar del Plata
    mov rcx,posiscion_mdq
    mov rdx,vector_mdq
    mov r8,mensaje_mdq
    call imprimirDestino

    ; Imprimo lo del destino Bariloche
    mov rcx,posiscion_bar
    mov rdx,vector_bar
    mov r8,mensaje_bar
    call imprimirDestino

    ; Imprimo lo del destino Posadas
    mov rcx,posiscion_pos
    mov rdx,vector_pos
    mov r8,mensaje_pos
    call imprimirDestino
    call clearScreen
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;                CLEAR SCREEN                ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearScreen:
    mov rdi,5
    clear:
        mov rcx,mensaje_salto_linea
        sub rsp,32
        call printf
        add rsp,32    
        dec rdi
        cmp rdi,0
        jne clear
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;             VALIDAR DESTINO                ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validarDestino:
    ;Destinos: Mar del Plata(M), Bariloche(B) y Posadas(P), devuelve rax 0 si es invalido o 1 si es valido
    cmp byte[destino],"M"
    je destinoValido
    cmp byte[destino],"B"
    je destinoValido
    cmp byte[destino],"P"
    je destinoValido
    ;Destino no es valido
    mov rcx,mensaje_destino_invalido
    sub rsp,32
    call printf
    add rsp,32

    mov rax,0 ;Lo tengo que poner abajo del call de printf porque o si no por algun motivo no se guarda bien
    ret
destinoValido:
    mov rax,1
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;               INGRESAR PESO                ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pesoInvalido:
    ;Peso no es valido
    mov rcx,mensaje_peso_invalido
    sub rsp,32
    call printf
    add rsp,32

ingresarPeso:
    mov rcx,input
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,input
    mov rdx,formato_numero
    mov r8,peso
    sub rsp,32
    call sscanf
    add rsp,32
    cmp rax,0

validarPeso:
    ;verificando que 0<Pi<=11, devuelve rax=1 valido o rax=0 si es invalido
    mov rax,1
    cmp dword[peso],0
    jle pesoInvalido ;Si es menor igual a 0 es invalido
    cmp dword[peso],11
    jg pesoInvalido
    ret
    
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;               VALIDAR OBJETOS              ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validarObjetos:
    ;verificando que 0<n<=20,
    mov rax,1
    cmp dword[cantidad_objetos],0
    jle objetosInvalidos ;Si es menor igual a 0 es invalido
    cmp dword[cantidad_objetos],20
    jg objetosInvalidos
    ret
objetosInvalidos:
    mov rcx,mensaje_objetos_invalido
    sub rsp,32
    call printf
    add rsp,32
    mov rax,0
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                            ;
;             AGREGAR A PAQUETE              ;
;                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
agregarPaqueteADestino:
    cmp byte[destino],"B"
    je agregarPaqueteBAR  
    cmp byte[destino],"P"
    je agregarPaquetePOS
    ;Si no es ninguno de los 2 es mdq
agregarPaqueteMDQ:
    mov rdi,[posiscion_mdq]
    mov edx,dword[peso]
    mov dword[vector_mdq + rdi*4],edx
    inc rdi
    mov [posiscion_mdq],rdi
    ret
agregarPaqueteBAR:
    mov rdi,[posiscion_bar]
    mov edx,dword[peso]
    mov dword[vector_bar + rdi*4],edx
    inc rdi
    mov [posiscion_bar],rdi
    ret    
agregarPaquetePOS:
    mov rdi,[posiscion_pos]
    mov edx,dword[peso]
    mov dword[vector_pos + rdi*4],edx
    inc rdi
    mov [posiscion_pos],rdi
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             ;
;          IMPRIMIR VECORES DESTINOS          ;
;                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imprimirDestino:
    ; En rcx = tamaño_vector , rdx= ptr_vector y r8=destino
    mov rax,qword[rcx]   ; Guardo temporalmente el tamaño del vector
    mov rbx,rdx   ; Guardo el puntero al vector de pesos en rbx
    mov r15,r8    ; Guardo destino en r15


    mov qword[indice],0
    mov qword[tamaño],rax



    ;Reviso si el destino tiene al menos un paquete
    cmp qword[tamaño],0
    je finImprimirDestino
    inc dword[contador_paquetes]    ; Aumento la cantidad de paquetes

siguientePaquete:
    mov dword[contador_peso],0
    mov dword[posicion_imprimir],0

    mov rdi,qword[tamaño]
    cmp qword[indice],rdi       ; Comparo el indice con el tamaño del vector
    jge finImprimirDestino         ; Si es igual no hay mas numeros e imprimo el paquete


    mov rsi,qword[indice]
    mov eax,dword[rbx + rsi*4]  ; guardo el primer peso
    inc qword[indice]           ; aumento el indice

    cmp eax,0                   ; Chequeo que el peso sea distinto de 0
    je siguientePaquete


    mov rsi,qword[posicion_imprimir]
    mov dword[vector_imprimir + rsi * 4],eax    ; Agrego el primer peso del paquete
    inc qword[posicion_imprimir]                ; Aumento el tamaño

    mov rdi,qword[tamaño]
    cmp qword[indice],rdi       ; Comparo el indice con el tamaño del vector
    jge imprimirPaquete         ; Si es igual no hay mas numeros e imprimo el paquete

    add dword[contador_peso],eax

calcularPeso:
    cmp dword[contador_peso],11
    je imprimirPaquete               ; Si el peso es 11 imprimo de una

    mov eax,11
    sub eax,dword[contador_peso]  ; calculo el proximo peso a buscar
    mov dword[peso_buscado],eax


    

    mov rsi,qword[indice]


    buscadorPeso:
        mov eax,dword[rbx + rsi*4]  ; guardo el primer peso en eax



        cmp EAX,dword[peso_buscado]
        je agregarPeso

        inc rsi           ; aumento el indice
        cmp rsi,qword[tamaño]
        jl  buscadorPeso

        ;Si llego aca es que no se encontro el primer peso buscado
        dec dword[peso_buscado]

        cmp dword[peso_buscado],0 
        jle  imprimirPaquete           ; SI el peso buscado es igual a 0 paso al siguiente paquete

        mov rsi, qword[indice]          ; Restasblesco el indice
        jmp buscadorPeso                ; Loop obligatorio a buscador peso con nuevo peso

    agregarPeso:
        mov eax,dword[rbx + rsi*4]  ; guardo el primer peso en eax
        mov dword[rbx + rsi*4],0        ;borro el peso
        add dword[contador_peso],eax


        mov rsi,qword[posicion_imprimir]
        mov dword[vector_imprimir + rsi * 4],eax  ; Agrego el peso al vector a imprimir

        inc qword[posicion_imprimir]

        jmp calcularPeso

imprimirPaquete:
    cmp qword[posicion_imprimir],0  ; Comparacion para evitar errores
    je finImprimirDestino

    ; Imprimo el destino
    mov rcx,formato_destino
    mov rdx,[contador_paquetes]
    mov r8,r15
    sub rsp,32
    call printf
    add rsp,32


    ; Imprimo el destino
    mov rcx,mensaje_primer_numero
    mov edx,dword[vector_imprimir]       ; Imprimo el primer peso
    sub rsp,32
    call printf
    add rsp,32

    mov rsi,1
    cmp rsi,qword[posicion_imprimir]
    je finImprimirPaquete

    imprimirVector:
        mov rcx,mensaje_numero
        mov edx,dword[vector_imprimir + rsi * 4]       ; Imprimo el peso
        sub rsp,32
        call printf
        add rsp,32

        inc rsi
        cmp rsi,qword[posicion_imprimir]
        jl imprimirVector                       ; Si es menor hay mas pesos que imprimir

finImprimirPaquete:
    mov rcx,mensaje_salto_linea
    sub rsp,32
    call printf
    add rsp,32
    inc dword[contador_paquetes]    ; Aumento la cantidad de paquetes

    mov rdi,qword[tamaño]
    cmp qword[indice],rdi       ; Comparo el indice con el tamaño del vector
    jl siguientePaquete

finImprimirDestino:
    ret




