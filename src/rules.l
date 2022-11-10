
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>

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

  /**
   * This variable is used to mark the current line that
   * is being analyzed by the lexer. Further, it is used
   * to inform which line has occurred a lexer error.
   */  
  unsigned int line_count = 1;
  
  /**
   * This variable is use to store the amount of invalid
   * characters that has been from the standard input.
   */
  unsigned int invalid_ch_count = 0;

  /**
   * This variable is used to store the options that is
   * provided by the user in the command-line tool.
   */
  unsigned int options = 0;

  /**
   * It prints the recognized token to the standard output. The message
   * that is going to be printed may be selected using the printing_type.
   * Further, the token name is used for the non-verbose messages that
   * may be selected from the command-line tool.
   */
  void print_token(const char *token_name, unsigned int printing_type);
%}

DIGIT          [0-9]
LETTER         [a-zA-Z'_']
ID             {LETTER}({LETTER}|{DIGIT})*
NUMBER         {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)? 
WS             [ \t]
EOL            [\n]
PLUS           "+"
MINUS          "-"
MUL            "*"
DIV            "/"
ASSIGN         ":="
PLUS_EQUAL     "+="
MINUS_EQUAL    "-="
MUL_EQUAL      "*="
DIV_EQUAL      "/="
NOT            not
AND            and
OR             or
EQUAL          "="
NOT_EQUAL      "!="
LT             "<"
LTE            "<="
GT             ">"
GTE            ">="
LPAREN         "("
RPAREN         ")"
LBRACKET       "["
RBRACKET       "]"
LBRACE         "{"
RBRACE         "}"
DOT            \.
COMMA          ,
SEMICOLON      ;
COLON          :
VOID           void
BOOL           bool
CHAR           char
SHORT          short
INTEGER        int
FLOAT          float
LONG           long
DOUBLE         double
RETURN         return
CONST          const
IF             if
ELSE           else
FOR            for
WHILE          while
SWITCH         switch
CASE           case
BREAK          break
CONTINUE       continue
TRUE           true
FALSE          false

%%
{WS}            // Ignore whitespace
{EOL} {
    line_count++;
}

{VOID}    |
{BOOL}    |
{CHAR}    |
{SHORT}   |
{INTEGER} |
{FLOAT}   |
{LONG}    |
{DOUBLE}  { print_token(yytext, PRINT_TOKEN_KEYWORD_DATATYPE); }

{RETURN}   | 
{CONST}    |
{IF}       |
{ELSE}     |
{FOR}      |
{WHILE}    | 
{SWITCH}   |  
{CASE}     |
{BREAK}    |
{CONTINUE} |
{TRUE}     |
{FALSE}    { print_token(yytext, PRINT_TOKEN_KEYWORD); }

{NUMBER}     { print_token("NUMBER", PRINT_TOKEN_NUMBER); }
{DIGIT}+{ID} { printf("Identificador inválido: \x1b[33m%s\x1b[0m na linha %d.\n", yytext, line_count); }

{NOT}       { print_token("NOT", PRINT_TOKEN_LOGICAL_OP); }
{AND}       { print_token("AND", PRINT_TOKEN_LOGICAL_OP); }
{OR}        { print_token("OR", PRINT_TOKEN_LOGICAL_OP); }
{EQUAL}     { print_token("EQUAL", PRINT_TOKEN_LOGICAL_OP); } 
{NOT_EQUAL} { print_token("NOT_EQUAL", PRINT_TOKEN_LOGICAL_OP); }
{LT}        { print_token("LT", PRINT_TOKEN_LOGICAL_OP); }
{LTE}       { print_token("LTE", PRINT_TOKEN_LOGICAL_OP); }
{GT}        { print_token("GT", PRINT_TOKEN_LOGICAL_OP); }
{GTE}       { print_token("GTE", PRINT_TOKEN_LOGICAL_OP); }

\".*\"                 { print_token("LITERAL_STRING", PRINT_TOKEN_LITERAL_STRING); }
\'({LETTER}|{DIGIT})\' { print_token("LITERAL_CHARACTER", PRINT_TOKEN_LITERAL_CHARACTER); }

{ID} { print_token("id", PRINT_TOKEN_IDENTIFIER); }

{ASSIGN}      { print_token("ASSIGN", PRINT_TOKEN); }

{PLUS}        { print_token("PLUS", PRINT_TOKEN_ARITHMETIC_OP); } 
{MINUS}       { print_token("MINUS", PRINT_TOKEN_ARITHMETIC_OP); }
{MUL}         { print_token("MUL", PRINT_TOKEN_ARITHMETIC_OP); }
{DIV}         { print_token("DIV", PRINT_TOKEN_ARITHMETIC_OP); }
{PLUS_EQUAL}  { print_token("PLUS_EUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{MINUS_EQUAL} { print_token("MINUS_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{MUL_EQUAL}   { print_token("MUL_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{DIV_EQUAL}   { print_token("DIV_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }

{SEMICOLON}  { print_token("SEMICOLON", PRINT_TOKEN_PUNCTUATION); }
{DOT}        { print_token("DOT", PRINT_TOKEN_PUNCTUATION); }
{COMMA}      { print_token("COMMA",  PRINT_TOKEN_PUNCTUATION); }
{LBRACE}     { print_token("LBRACE", PRINT_TOKEN_PUNCTUATION); }
{RBRACE}     { print_token("RBRACE", PRINT_TOKEN_PUNCTUATION); }
{LPAREN}     { print_token("LPAREN", PRINT_TOKEN_PUNCTUATION); }
{RPAREN}     { print_token("RPAREN", PRINT_TOKEN_PUNCTUATION); }
{LBRACKET}   { print_token("LBRACKET", PRINT_TOKEN_PUNCTUATION); }
{RBRACKET}   { print_token("RBRACKET", PRINT_TOKEN_PUNCTUATION); }
{COLON}      { print_token("COLON", PRINT_TOKEN_PUNCTUATION); }

. {
    printf("Caractere desconhecido: \x1b[33m%s\x1b[0m na linha %d.\n", yytext, line_count);
    invalid_ch_count++;
}

%%

void print_token(const char *token_name, unsigned int printing_type) {
    /* It checks if the non-verbose messages has been selected. */
    if (options & OPT_NO_VERBOSE_BIT) {
      printf("<%s, %s>\n", token_name == NULL ? yytext : token_name, yytext);
      return;
    }

    switch (printing_type) {
      case PRINT_TOKEN:
        printf("O token \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_KEYWORD:
        printf("A palavra-chave \x1b[33m%s\x1b[0m foi reconhecida!\n", yytext);
        break;
      case PRINT_TOKEN_KEYWORD_DATATYPE:
        printf("A palavra-chave \x1b[33m%s\x1b[0m que é um tipo de dado foi reconhecida!\n", yytext);
        break;
      case PRINT_TOKEN_IDENTIFIER:
        printf("O identificador \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_NUMBER:
        printf("O número \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_LITERAL_STRING: 
        printf("O literal de string \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_LOGICAL_OP:
        printf("O operador lógico \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_ARITHMETIC_OP:
        printf("O operador aritmético \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_PUNCTUATION:
        printf("O caractere de pontuação \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_LITERAL_CHARACTER:
        printf("O literal de caractere \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
   }
}

int main(int argc, char **argv) {
    --argc, ++argv;

    if (argc > 0 && argv[0][0] != '-') {
        yyin = fopen(argv[0], "r");

        --argc, ++argv;
    } else {
        yyin = stdin;
    }
  
    while (argc > 0) {
      argc--;
      if (strcmp(argv[argc], "--debug") == 0)
        options |= OPT_DEBUG_BIT;
      else if (strcmp(argv[argc], "--no-verbose") == 0)
        options |= OPT_NO_VERBOSE_BIT;
    }

    yylex();

    if (options & OPT_DEBUG_BIT) {
      printf("\n[DEBUG]\n");
      printf("Line Count: %d.\n", line_count);
      printf("Invalid Character Count: %d.\n", invalid_ch_count);
    }
}
