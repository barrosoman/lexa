LEXIC_CODE	    := src/lexic.c
LEXIC			:= src/lexic.l
SYNTAX_CODE     := src/parser.c
SYNTAX_HEADER   := src/parser.h
SYNTAX			:= src/parser.y
BISON_DIR               := /usr/share/bison

OUTPUT			:= lexa
TEST			:= $(notdir $(wildcard tests/*))

build:
	bison --header=src/parser.h -o src/parser.c src/parser.y
	flex -o $(LEXIC_CODE) $(LEXIC)
	gcc -o $(OUTPUT) $(LEXIC_CODE) $(SYNTAX_CODE)

test: build
	$(foreach file, $(TEST), ./$(OUTPUT) tests/$(file) > results/$(file).result;)

html: build
	bison -x $(SYNTAX) -o parser.xml
	xsltproc $(BISON_DIR)/xslt/xml2xhtml.xsl parser.xml > parser.html

clean:
	rm $(LEXIC_CODE) $(OUTPUT)
