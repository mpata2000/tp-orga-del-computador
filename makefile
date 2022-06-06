CC = gcc
NASMFLAGS = win64
MAIN = tp-6.asm
OBJETOS = tp-6.o
EXEC = tp-6
FILES = tp-6.asm makefile  README.md

nasm:
	nasm -f $(NASMFLAGS) tp-6.asm -o $(OBJETOS)

gcc: nasm
	$(CC) ./$(MAIN) -o $(EXEC)

run: nasm $(EXEC)
	cls         
	./$(EXEC)  

zip: 
	zip -r $(EXEC).zip *.c *.h $(FILES)

.PHONY: clean
clean:
	rm -f *.o $(EXEC)