build:
	flex -o src/generated_code.c  src/rules.l
	gcc -o lexa src/generated_code.c -lfl -lm

clean:
	rm src/generated_code.c lexa
