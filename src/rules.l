
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>

  #define OPT_DEBUG_BIT      (0x1)
  #define OPT_NO_VERBOSE_BIT (0x2)

  #define PRINT_TOKEN                  (0x0)
  #define PRINT_TOKEN_KEYWORD          (0x1)
  #define PRINT_TOKEN_KEYWORD_DATATYPE (0x2)
  #define PRINT_TOKEN_IDENTIFIER       (0x3)
  #define PRINT_TOKEN_NUMBER           (0x4)
  #define PRINT_TOKEN_STRING           (0x5)
  #define PRINT_TOKEN_LOGICAL_OP       (0x6)
  #define PRINT_TOKEN_ARITHMETIC_OP    (0x7)

  /**
   * This variable is used to mark the current line that
   * is being analyzed by the lexer. Further, it is used
   * to inform which line has occurred a lexer error.
   */  
   unsigned int line_count = 1;
  
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
AND            "AND"
OR             "OR"
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

{NUMBER}     { print_token("number", PRINT_TOKEN_NUMBER); }
{DIGIT}+{ID} { printf("O número \x1b[33m%s\x1b[0m na linha %d é inválido.\n", yytext, line_count); }

{AND}       { print_token("AND", PRINT_TOKEN_LOGICAL_OP); }
{OR}        { print_token("OR", PRINT_TOKEN_LOGICAL_OP); }
{EQUAL}     { print_token("EQUAL", PRINT_TOKEN_LOGICAL_OP); } 
{NOT_EQUAL} { print_token("NOT_EQUAL", PRINT_TOKEN_LOGICAL_OP); }
{LT}        { print_token("LT", PRINT_TOKEN_LOGICAL_OP); }
{LTE}       { print_token("LTE", PRINT_TOKEN_LOGICAL_OP); }
{GT}        { print_token("GT", PRINT_TOKEN_LOGICAL_OP); }
{GTE}       { print_token("GTE", PRINT_TOKEN_LOGICAL_OP); }

\".*\" { print_token("string", PRINT_TOKEN_STRING); }

{ID} { print_token("id", PRINT_TOKEN_IDENTIFIER); }

{ASSIGN}      { print_token("assign", PRINT_TOKEN); }

{PLUS}        { print_token("PLUS", PRINT_TOKEN_ARITHMETIC_OP); } 
{MINUS}       { print_token("MINUS", PRINT_TOKEN_ARITHMETIC_OP); }
{MUL}         { print_token("MUL", PRINT_TOKEN_ARITHMETIC_OP); }
{DIV}         { print_token("DIV", PRINT_TOKEN_ARITHMETIC_OP); }
{PLUS_EQUAL}  { print_token("PLUS_EUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{MINUS_EQUAL} { print_token("MINUS_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{MUL_EQUAL}   { print_token("MUL_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }
{DIV_EQUAL}   { print_token("DIV_EQUAL", PRINT_TOKEN_ARITHMETIC_OP); }

{SEMICOLON} { print_token("semicolon", PRINT_TOKEN); }
{COMMA}     { print_token("comma",  PRINT_TOKEN); }
{LBRACE}    { print_token("lbrace", PRINT_TOKEN); }
{RBRACE}    { print_token("rbrace", PRINT_TOKEN); }
{LPAREN}    { print_token("lparen", PRINT_TOKEN); }
{RPAREN}    { print_token("rparen", PRINT_TOKEN); }
{LBRACKET}  { print_token("lbracket", PRINT_TOKEN); }
{RBRACKET}  { print_token("rbracket", PRINT_TOKEN); }
{COLON}     { print_token("colon", PRINT_TOKEN); }

. {
    printf("Unrecognized character: %s at line %d\n", yytext, line_count);
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
      case PRINT_TOKEN_STRING: 
        printf("A string \x1b[33m%s\x1b[0m foi reconhecida!\n", yytext);
        break;
      case PRINT_TOKEN_LOGICAL_OP:
        printf("O operador lógico \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
        break;
      case PRINT_TOKEN_ARITHMETIC_OP:
        printf("O operador aritmético \x1b[33m%s\x1b[0m foi reconhecido!\n", yytext);
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

    if (options & OPT_DEBUG_BIT)
      printf("DEBUG: Line_count = %d\n", line_count);
}
