GENERATED_CODE	:= src/generated_code.c
RULES			:= src/rules.l
OUTPUT			:= lexa
TEST			:= $(notdir $(wildcard tests/*))

build:
	flex -o $(GENERATED_CODE) $(RULES)
	gcc -o $(OUTPUT) $(GENERATED_CODE)

test: build
	$(foreach file, $(TEST), ./$(OUTPUT) tests/$(file) > results/$(file).result;)

clean:
	rm $(GENERATED_CODE) $(OUTPUT)
