CC = gcc
NASMFLAGS = win64
MAIN = tp-6.asm
OBJETO = tp-6.o
EXEC = tp-6.exe
FILES = tp-6.asm makefile  README.md

$(OBJETO):
	nasm -f $(NASMFLAGS) $(MAIN) -o $(OBJETO)

$(EXEC): $(OBJETO)
	$(CC) ./$(OBJETO) -o $(EXEC)

.PHONY: run
run: clean $(EXEC)
	- ./$(EXEC)

zip: 
	zip -r $(EXEC).zip *.c *.h $(FILES)

.PHONY: clean
clean:
	- del -rf $(OBJETO) $(EXEC) 