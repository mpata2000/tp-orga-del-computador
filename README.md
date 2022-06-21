# TP 6 - Martin Pata

Trabajo practico desarrollado para la materia []Organizacion del Computador - Catedra Benitez

El tp se desarrollo para Windows con nasm assembler Intel 80x86

## Enunciado

Se tienen n objetos de pesos P1, P2, ..., Pn (con n <= 20) que deben ser enviados por correo a una misma dirección. La forma más simple sería ponerlos todos en un mismo paquete; sin embargo, el correo no acepta que los paquetes tengan más de 11 Kg. y la suma de los pesos podría ser mayor que eso. Afortunadamente, cada uno de los objetos no pesa más de 11 Kg.

Se trata entonces de pensar un algoritmo que de un método para armar los paquetes, tratando de optimizar su cantidad. Debe escribir un programa en **assembler Intel 80x86** que:

- Permita la entrada de un entero positivo n.
- La entrada de los n pesos, verificando que `0<Pi<=11 donde i <=n`.
- Los `Pi` pueden ser valores enteros.
- Exhiba en pantalla la forma en que los objetos deben ser dispuestos en los paquetes.

A su vez existen tres destinos posibles: Mar del Plata, Bariloche y Posadas. El correo por normas internas de funcionamiento no puede poner en el mismo paquete objetos que vayan a distinto destino. Desarrollar un algoritmo que proporcione una forma de acomodar los paquetes de forma que no haya objetos de distinto destino en un mismo paquete y cumpliendo las restricciones de peso. Se sugiere tener una salida como la siguiente:

- Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)
- Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)
- Destinoi – Objeto1 (P1) + Objeto2 (P2)+ ..... + Objeton (Pn)

## Makefile

Con en trabajo se proporciona un makefile para hacer la compilacion y la corrida del trabajo mas facil.

`make run` corre el tp (Al correrlo con make va a detectar un error de retorno que no es relevante)
`make zip` comprime los archivos del tp

### Instalacion de makefile en windows

1. Instalar [chocolatey package manager](https://chocolatey.org/install)
2. Correr en powershell como admin `choco install make`
3. Correr en powershell como admin `choco install zip` (sin esto no correr make zip)

Credito a: https://stackoverflow.com/questions/2532234/how-to-run-a-makefile-in-windows

### Make zip

El comando make zip se puede correr perfectamente desde WSL que tenga acceso al directorio con todos los archivos del tp

## Corrida Manual

Se tienen que correr los siguentes comandos donde se requiere tener [nasm](https://www.nasm.us/) y [Mingw64](https://www.mingw-w64.org/downloads/):

1. `nasm -f win64 7503-TP-06-106226.asm -o 7503-TP-06-106226.o`
2. `gcc 7503-TP-06-106226.o -o 7503-TP-06-106226.exe`
3. `./7503-TP-06-106226.exe`
