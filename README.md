# Lexa
Project for an lexical analyzer using flex.

## Instructions

### Build

```Makefile
make build
```

or only 

```Makefile
make
```

### Clean the created binary and generated code

```Makefile
make clean
```

### Test the test files from _tests_ and put the new results in _results_

```Makefile
make test
```

## Instructions without make

```bash
bison --header=src/parser.h -o src/parser.c src/parser.y
flex -o src/scanner.c src/scanner.l
gcc -o lexa src/parser.c src/scanner.c
```
