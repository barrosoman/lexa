GENERATED_CODE=src/generated_code.c
RULES=src/rules.l
LIBS=-lfl -lm
OUTPUT=lexa

build:
	flex -o ${GENERATED_CODE} ${RULES}
	gcc -o ${OUTPUT} ${GENERATED_CODE} ${LIBS}

clean:
	rm ${GENERATED_CODE} ${OUTPUT}
