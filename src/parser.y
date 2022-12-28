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
%token LET WHILE FOR DO END UNTIL IF ELSE THEN

%start main

%%

main:           statements
;


statements:     function statements
|               declaration SEMICOLON statements
|               assignment SEMICOLON statements
|               loop statements
|               function_call SEMICOLON statements
|               cond statements
|               %empty
;

function_call:  ID LPAREN pars RPAREN
;

function:       PROCEDURE ID LPAREN pars RPAREN COLON DATATYPE
                statements
                END PROCEDURE
;

operands:       STRING
|               NUMBER
|               ID
|               arit_exp
|               function_call
|               LPAREN operands RPAREN
;

// Arithmetic expressions
arit_exp:       operands ARITHMETIC_OP operands
;

logic_exp:      operands RELATION_OP operands
|               LPAREN operands RELATION_OP operands RPAREN
|               operands
;

pars:           ID COLON DATATYPE pars_aux
|               operands pars_aux
|               %empty
;

pars_aux:       COMMA ID COLON DATATYPE pars_aux
|               COMMA operands pars_aux
|               %empty
;

declaration:    LET ID COLON DATATYPE decl_aux
|               LET ID COLON DATATYPE ASSIGN operands
;
decl_aux:       COMMA ID COLON DATATYPE decl_aux
|               %empty

assignment:     ID ASSIGN operands { printf("Assignment statement recognized.\n"); }
;

cond:           IF logic_exp THEN
                    statements
                    cond_aux
                END IF { printf("If statement recognized.\n"); }
;
cond_aux:       ELSE statements 
              | %empty
;

loop:           FOR declaration SEMICOLON logic_exp SEMICOLON assignment DO
                    statements
                END FOR { printf("For loop statement recognized.\n"); }
              | WHILE logic_exp DO
                    statements
                END WHILE { printf("While loop statement recognized.\n"); }
              | DO
                    statements
                UNTIL logic_exp 
                { printf("Do-Until loop statement recognized.\n"); }
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
