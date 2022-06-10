AS = nasm
CC = gcc
NASMFLAGS = win64
MAIN = 7503-TP-06-106226
OBJETO = 7503-TP-06-106226.o
EXEC = 7503-TP-06-106226.exe
FILES = 7503-TP-06-106226.asm makefile  README.md

compile:
	$(AS) -f $(NASMFLAGS) $(MAIN).asm -o $(OBJETO)
	$(CC) ./$(OBJETO) -o $(EXEC)

run: compile
	cls 			
	- ./$(EXEC)

zip: 
	zip -r $(MAIN).zip $(FILES)

.PHONY: clean
clean:
	- del -rf $(OBJETO) $(EXEC) 