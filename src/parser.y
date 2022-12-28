/*
  Seção de comentátios
*/    

%{
#include <stdio.h>
    int yylex();
    int yyparse();
    int errors = 0;
    extern FILE * yyin;
    extern int yylineno;
    void yyerror (const char *s) {
        printf("Erro encontrado na linha %d: %s \n", yylineno, s);
        errors++;
    }


        %}

%define parse.error verbose

%token LPAREN RPAREN SEMICOLON COLON COMMA
%token ARITHMETIC_OP LOGICAL_OP RELATION_OP ASSIGN
%token NUMBER ID STRING
%token PROCEDURE
%token DATATYPE
%token LET WHILE FOR DO END UNTIL IF ELSE

%start main

%%

main:          statements
;


statements: function statements
|       declaration SEMICOLON statements
|       assignment SEMICOLON statements
|       loop statements
|       function_call SEMICOLON statements
|       cond statements
|       %empty
;

function_call: ID LPAREN begin_parameters RPAREN
;

function: PROCEDURE ID LPAREN begin_parameters RPAREN COLON DATATYPE statements END PROCEDURE
;

command_block: statements
;

operands: STRING | NUMBER | ID | arit_exp | LPAREN operands RPAREN | function_call
;

// Arithmetic expressions
arit_exp: operands ARITHMETIC_OP operands
;

logic_exp: operands RELATION_OP operands
| operands
;

begin_parameters: ID COLON DATATYPE parameters
| operands parameters
| %empty
;

parameters:     COMMA ID COLON DATATYPE parameters
|       COMMA operands parameters
|       %empty
;

declaration:    LET ID COLON DATATYPE
|       LET ID COLON DATATYPE ASSIGN operands
;

assignment:     ID ASSIGN operands 
;

cond: IF LPAREN logic_exp RPAREN command_block cond_aux;
cond_aux: ELSE command_block 
    | %empty;

loop:           FOR LPAREN declaration SEMICOLON logic_exp SEMICOLON assignment RPAREN DO command_block END FOR
|       WHILE LPAREN logic_exp RPAREN command_block END WHILE
|       DO command_block UNTIL LPAREN logic_exp RPAREN
;
%%

int main(int argc, char **argv) {
    --argc, ++argv;

    if (argc > 0 && argv[0][0] != '-') {
        yyin = fopen(argv[0], "r");

        --argc, ++argv;
    } else {
        yyin = stdin;
    }

    do {
        yyparse();
    } while (!feof(yyin));

    if (errors == 0) {
        printf("No syntatic errors during parsing!\n");
    }
  

    yylex();
}
