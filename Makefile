# NUME: ANGHEL MIHAI-GABRIEL    GRUPA: 336CC


INPUT = in/example1.txt in/example2.txt in/myexample1.txt in/myexample2.txt in/myexample3.txt in/myexample4.txt

build:
	flex tema.l
	gcc lex.yy.c
run:
	./a.out $(INPUT)
clean: 
	rm -rf a.out lex.yy.c
