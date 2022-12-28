%option noyywrap 

%{
  #include "lexa.h"
  #include "parser.h"

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

%option yylineno

DIGIT          [0-9]
LETTER         [a-zA-Z'_']
ID             {LETTER}({LETTER}|{DIGIT})*
NUMBER         {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)? 
COMMENT        #.*\n
WS             [ \t]
EOL            \r?\n
PLUS           "+"
MINUS          "-"
MUL            "*"
DIV            "/"
ASSIGN         "="
PLUS_ASSIGN    "+="
MINUS_ASSIGN   "-="
MUL_ASSIGN     "*="
DIV_ASSIGN     "/="
NOT            not
AND            and
OR             or
EQUAL          "=="
NOT_EQUAL      "!="
LT             "<"
LTE            "<="
GT             ">"
GTE            ">="
LPAREN         "("
RPAREN         ")"
LBRACKET       "["
RBRACKET       "]"
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
END	           end
DO             do
PROCEDURE      procedure
UNTIL          until
LET            let
THEN           then


%%
{WS}            // Ignore whitespace
{COMMENT} {  // Ignore comments
    line_count++;
}
{EOL} {
    line_count++;
}

{VOID}       { return (VOID);    }
{BOOL}       { return (BOOL);    }
{CHAR}       { return (CHAR);    }
{SHORT}      { return (SHORT);   }
{INTEGER}    { return (INTEGER); }
{FLOAT}      { return (FLOAT);   }
{LONG}       { return (LONG);    }
{DOUBLE}     { return (DOUBLE);  }

{NUMBER}     { return (NUMBER); }
{DIGIT}+{ID} { printf("Identificador inválido: %s%s%s na linha %d.\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET, line_count);}

{TRUE}       { return (TRUE);  }
{FALSE}      { return (FALSE); }
{NOT}        { return (NOT);   }
{AND}        { return (AND);   }
{OR}         { return (OR);    }

{EQUAL}      { return (EQUAL);     }
{NOT_EQUAL}  { return (NOT_EQUAL); }
{LT}         { return (LT);        }
{LTE}        { return (LTE);       }
{GT}         { return (GT);        }
{GTE}        { return (GTE);       }

\".*\"                 { return (STRING); }
\'({LETTER}|{DIGIT})\' { return (CHAR);}

{LET}       { return (LET);       }
{DO}        { return (DO);        }
{END}       { return (END);       }
{WHILE}     { return (WHILE);     }
{FOR}       { return (FOR);       }
{PROCEDURE} { return (PROCEDURE); }
{THEN}      { return (THEN);      }
{UNTIL}     { return (UNTIL);     }
{IF}        { return (IF);        }
{ELSE}      { return (ELSE);      }
{SWITCH}    { return (SWITCH);    }
{CASE}      { return (CASE);      }
{RETURN}    { return (RETURN);    }
{ID}        { return (ID);        }


{PLUS}  { return (PLUS);  } 
{MINUS} { return (MINUS); }
{MUL}   { return (MUL);   }
{DIV}   { return (DIV);   }

{ASSIGN}       { return (ASSIGN); }

{PLUS_ASSIGN}   { return (ASSIGN_PLUS);  }
{MINUS_ASSIGN}  { return (ASSIGN_MINUS); }
{MUL_ASSIGN}    { return (ASSIGN_MUL);   }
{DIV_ASSIGN}    { return (ASSIGN_DIV);   }

{SEMICOLON}  { return (SEMICOLON); }
{COMMA}      { return (COMMA);     } 
{LPAREN}     { return (LPAREN);    }
{RPAREN}     { return (RPAREN);    }
{LBRACKET}   { return (LBRACKET);  }
{RBRACKET}   { return (RBRACKET);  }
{COLON}      { return (COLON);     }

. {
    printf("Caractere desconhecido: %s%s%s na linha %d.\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET, line_count);
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
        printf("O token %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_KEYWORD:
        printf("A palavra-chave %s%s%s foi reconhecida!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_KEYWORD_DATATYPE:
        printf("A palavra-chave %s%s%s que é um tipo de dado foi reconhecida!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_IDENTIFIER:
        printf("O identificador %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_NUMBER:
        printf("O número %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_LITERAL_STRING: 
        printf("O literal de string %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_LOGICAL_OP:
        printf("O operador lógico %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_ARITHMETIC_OP:
        printf("O operador aritmético %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_PUNCTUATION:
        printf("O caractere de pontuação %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_LITERAL_CHARACTER:
        printf("O literal de caractere %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
      case PRINT_TOKEN_ASSIGN_OP:
        printf("O operador de atribuição %s%s%s foi reconhecido!\n", CONSOLE_COLOR_YELLOW, yytext, CONSOLE_COLOR_RESET);
        break;
   }
}

