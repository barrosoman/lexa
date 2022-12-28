#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyparse();

#ifdef __linux__
  #define CONSOLE_COLOR_YELLOW "\x1b[33m"
  #define CONSOLE_COLOR_RESET  "\x1b[0m"
#else
  #define CONSOLE_COLOR_YELLOW ""
  #define CONSOLE_COLOR_RESET  ""
#endif

#define OPT_DEBUG_BIT      (0x1)
#define OPT_NO_VERBOSE_BIT (0x2)

#define PRINT_TOKEN                   (0x0)
#define PRINT_TOKEN_KEYWORD           (0x1)
#define PRINT_TOKEN_KEYWORD_DATATYPE  (0x2)
#define PRINT_TOKEN_IDENTIFIER        (0x3)
#define PRINT_TOKEN_NUMBER            (0x4)
#define PRINT_TOKEN_LITERAL_STRING    (0x5)
#define PRINT_TOKEN_LOGICAL_OP        (0x6)
#define PRINT_TOKEN_ARITHMETIC_OP     (0x7)
#define PRINT_TOKEN_PUNCTUATION       (0x8)
#define PRINT_TOKEN_LITERAL_CHARACTER (0x9)
#define PRINT_TOKEN_ASSIGN_OP         (0xA)
