/*
  Seção de comentátios
*/    

%{
#include "lexa.h"
    int errors = 0;
    extern FILE * yyin;
    extern int yylineno;

    void yyerror (const char *s) {
        printf("Erro encontrado na linha %d: %s \n", yylineno, s);
        errors++;
    }

    void print_statement(char *s) {
        printf("%s%s%s statement was recognized.\n", CONSOLE_COLOR_YELLOW, s, CONSOLE_COLOR_RESET);
    }
%}

%define parse.error verbose

%token LPAREN RPAREN SEMICOLON COLON COMMA 
%token MINUSMINUS PLUSPLUS
%token ARITHMETIC_OP LOGICAL_OP RELATION_OP ASSIGN  ASSIGN_ARIT_OP 
%token NUMBER ID STRING CHAR BOOL NOT 
%token PROCEDURE
%token DATATYPE
%token LET WHILE FOR DO END UNTIL IF ELSE THEN

%start main

%%

// Beginning of a file
main:           statements
;

// Generic statements
statements:     function statements
|               declaration SEMICOLON statements
|               assignment SEMICOLON statements
|               loop statements
|               function_call SEMICOLON statements
|               cond statements
|               %empty
;

// A function call syntax
function_call:  ID LPAREN pars RPAREN
                { print_statement("Function call"); }
;

// A function formation
function:       PROCEDURE ID LPAREN pars RPAREN COLON DATATYPE
                statements
                END PROCEDURE
                { print_statement("A Function"); }
;

// Basic variables
operands:       STRING
|               NUMBER
|               ID
|               BOOL
|               CHAR
|               arit_exp
|               function_call
|               LPAREN operands RPAREN
;

// Arithmetic expressions
arit_exp:       operands ARITHMETIC_OP operands
;

// Logic expressions
logic_exp:      operands RELATION_OP operands
|               LPAREN operands RELATION_OP operands RPAREN
|               operands
|               NOT operands
;

// Parameters
pars:           ID COLON DATATYPE pars_aux
|               operands pars_aux
|               %empty
;
pars_aux:       COMMA ID COLON DATATYPE pars_aux
|               COMMA operands pars_aux
|               %empty
;

// Declaration of variables
declaration:    LET ID COLON DATATYPE decl_aux { print_statement("Declaration"); }
|               LET ID COLON DATATYPE ASSIGN operands { print_statement("Declaration"); }
;
decl_aux:       COMMA ID COLON DATATYPE decl_aux  { print_statement("Declaration"); }
|               %empty
;

// Assignment of variables
assignment:     ID ASSIGN operands { print_statement("Assignment"); }
|               ID ASSIGN_ARIT_OP operands { print_statement("Assignment"); }
|               ID PLUSPLUS { print_statement("Assignment"); }
|               ID MINUSMINUS { print_statement("Assignment"); }
;

// If syntax
cond:           IF logic_exp THEN
                    statements
                    cond_aux
                END IF { print_statement("If"); }
;
cond_aux:       ELSE statements { print_statement("Else"); }
              | %empty
;

// Loops formation
loop:           FOR declaration SEMICOLON logic_exp SEMICOLON assignment DO
                    statements
                END FOR { print_statement("For"); }
              | WHILE logic_exp DO
                    statements
                END WHILE { print_statement("While"); }
              | DO
                    statements
                UNTIL logic_exp 
                { print_statement("Do-Until"); }
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
}
