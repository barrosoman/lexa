build:
	flex -o src/generated_code.c  src/rules.l
	gcc -o lexa src/generated_code.c -lfl -lm

clean:
	rm src/generate_code.c lexa

run: build
	./lexa temp_file
