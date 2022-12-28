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

/**
 * Datatype tokens.
 */
%token VOID
%token BOOL
%token CHAR
%token SHORT
%token INTEGER
%token FLOAT
%token LONG
%token DOUBLE

/**
 * Assignment operator.
 */
%token ASSIGN
%token ASSIGN_ARIT_OP

/**
 * Arithmetic Operators.
 */
%token PLUS
%token MINUS
%token MUL
%token DIV

/**
 * Comparison Operators.
 */
%token EQUAL
%token NOT_EQUAL
%token LT
%token LTE
%token GT
%token GTE

/**
 * Logical Operators & Logical Literals.
 */
%token NOT
%token AND
%token OR
%token TRUE
%token FALSE

/**
 * Punctuation tokens.
 */
%token LPAREN 
%token RPAREN
%token SEMICOLON
%token COLON
%token COMMA


/**
 * Identifier token.
 */
%token ID

/**
 * Numeric & string literals.
 */
%token NUMBER
%token STRING
%token CHARACTER


/**
 * Keywords.
 */
%token LET
%token PROCEDURE
%token WHILE
%token FOR
%token DO
%token UNTIL
%token IF
%token THEN
%token ELSE
%token SWITCH
%token CASE
%token RETURN
%token END

%start main

%%

// Beginning of a file
main:           statements
;

statements: procedure statements
|       declaration SEMICOLON statements
|       attribution SEMICOLON statements
|       decl_attrib SEMICOLON statements
|       return_statement SEMICOLON statements
|       loop statements
|       procedure_call SEMICOLON statements
|       conditional statements
|       switch statements
|       %empty
;

/**
 * Type syntax-specifier (in BNF-notation).
 *
 *  <type> ::= void | bool | char | short | int | float | long | double;
 */
type: VOID
|     BOOL
|     CHAR
|     SHORT
|     INTEGER
|     FLOAT
|     LONG
|     DOUBLE
;

/**
 * Parsing a procedure (in BNF-notation).
 *
 *  <procedure> ::= procedure id ( <procedure-params> ): <type> { <statements } end procedure
 *  <procedure-params> ::= id: type { , id: type }
 *
 */
procedure: PROCEDURE ID LPAREN procedure_params RPAREN COLON type statements END PROCEDURE
               { print_statement("Procedure"); }
;
procedure_params: ID COLON type
|                 ID COLON type COMMA procedure_params
;

/**
 * Parsing a procedure-call (in BNF-notation).
 *
 *  <procedure-call> ::= id ( <procedure-args> )
 *  <procedure-args> ::= <operands> { , <operands> }
 *
 */
procedure_call: ID LPAREN procedure_args RPAREN
               { print_statement("Procedure Call"); }
;
procedure_args: operands
|               operands COMMA procedure_args
;

/**
 * Parsing a return statement (in BNF-notation).
 *
 *  <return-statement> ::= return <operands>
 *
 */
return_statement: RETURN operands
;

/**
 * Parsing operands (in BNF-notation).
 * 
 *  <operands> ::= string         |
 *                 number         | 
 *                 id             | 
 *                 <arith-expr>   |
 *                 <logic-expr>   |
 *                 ( <operands> )
 *
 */
operands: STRING | NUMBER | ID | CHARACTER | arith_expr | logic_expr | LPAREN operands RPAREN
;

/**
 * Parse an arithmetic expression (in BNF-notation).
 *
 * The productions provided for this arithmetic expressions
 * already provides higher precedence for multiply and
 * divide operations with relation to the addition and
 * subtraction ones.
 *
 *  <arith-expr>   ::= <arith-expr> + <arith-term> |
 *                     <arith-expr> - <arith-term> |
 *                     <arith-term>
 *  <arith-term>   ::= <arith-term> * <arith-factor> |
 *                     <arith-term> / <arith-factor>
 *                     <arith-factor>
 *  <arith-factor> ::= id
 *                     number            |
 *                     <function-call>   |
 *                     ( <arith-expr> )
 *
 */
arith_expr: arith_expr PLUS arith_term
|           arith_expr MINUS arith_term
|           arith_term
;
arith_term: arith_term MUL arith_factor
|           arith_term DIV arith_factor
|           arith_factor
;
arith_factor: ID
|             NUMBER
|             procedure_call
|             LPAREN arith_expr RPAREN
;

/**
 * Parse a logical expression (in BNF-notation).
 *
 * The productions provided for this logical expressions
 * already provides higher precedence for NOT, followed
 * by AND and followed by OR.
 *
 *  <logic-expr>   ::= <logic-expr> or <logic-term> |
 *                     <logic-term>
 *  <logic-term>   ::= <logic-term> and <logic-factor> |
 *                     <logic-factor>
 *  <logic-factor> ::= not <logic-factor> |
 *                     ( <logic-expr> )   |
 *                     true               |
 *                     false
 */
logic_expr: logic_expr OR logic_term
|           logic_term
;
logic_term: logic_term AND logic_factor
|           logic_factor
;
logic_factor: NOT logic_factor
|             LPAREN logic_expr RPAREN
|             TRUE
|             FALSE
|             comp_expr
;

/**
 * Parse a comparison expression (in BNF-notation).
 *
 * The produces provided for this comparison expressions
 * alreayd provides higher precedence for '>', '<=', '>'
 * and '>=' operators than '==', '!=' ones.
 *
 *  <comp-expr>   ::= <comp-expr> == <comp-term> |
 *                    <comp-expr> != <comp-term> |
 *                    <comp-term>
 *  <comp-term>   ::= <comp-term> '<'  <comp-factor> |
 *                    <comp-term> '<=' <comp-factor> |
 *                    <comp-term> '>'  <comp-factor> |
 *                    <comp-term> '>=' <comp-factor> |
 *                    <comp-factor>
 *  <comp-factor> ::= <arith-expr>
 *
 */
comp_expr: comp_expr EQUAL comp_term
|          comp_expr NOT_EQUAL comp_term
|          comp_term
;
comp_term: comp_term LT comp_factor
|          comp_term LTE comp_factor
|          comp_term GT comp_factor
|          comp_term GTE comp_factor
|          comp_factor
;
comp_factor: arith_expr
;


/**
 * Parse a declaration (in BNF-notation).
 *
 *  <declaration-after-let> ::= id: <type> { , <declaration-after-let> }
 *  <declaration>           ::= let <declaration-after-let>
 *
 */
declaration_after_let: ID COLON type
|                      ID COLON type COMMA declaration_after_let
               { print_statement("Declaration"); }
;
declaration: LET declaration_after_let
               { print_statement("Declaration"); }
;

/**
 * Parse an attribution (in BNF-notation).
 *
 *  <attribution> ::= id = <operands>  |
 *                    id += <operands> |
 *                    id -= <operands> |
 *                    id *= <operands> |
 *                    id /= <operands> |
 *                    id++             |
 *                    id--             |
 *                    ++id             |
 *                    --id
 *
 */
attribution: ID ASSIGN operands       /* Assignment operator              */ 
|            ID PLUS ASSIGN operands  /* Addition assignment operator     */
|            ID MINUS ASSIGN operands /* Subtraction assignmewnt operator */
|            ID MUL ASSIGN operands   /* Multiply assignment operator     */
|            ID DIV ASSIGN operands   /* Divide assignment operator       */
|            ID PLUS PLUS             /* Increment postfix operator       */
|            ID MINUS MINUS           /* Decrement postfix operator       */
|            PLUS PLUS ID             /* Increment prefix operator        */
|            MINUS MINUS ID           /* Decrement prefix operator        */
;

/**
 * Parse a declaration with attribution (in BNF-notation).
 *
 *   <decl-attrib-post-let> ::= id: <type> = <operands> { , <decl-attrib-post-let> }
 *   <decl-attrib>          ::= let <decl-attrib-post-let>
 *
 */
decl_attrib_post_let: ID COLON type ASSIGN operands
|                     ID COLON type ASSIGN operands COMMA decl_attrib_post_let
               { print_statement("Declaration"); }
;
decl_attrib: LET decl_attrib_post_let
               { print_statement("Declaration"); }
;

/**
 * Parse a if-then-else condition (in BNF-notation).
 *
 *  <conditional> ::= if <logic-expr> then { <statements> } end if |
 *                ::= if <logic-expr> then { <statements> } else { <statements >} end if
 *
 */
conditional: IF logic_expr THEN statements END IF
               { print_statement("If"); }
|            IF logic_expr THEN statements ELSE statements END IF
               { print_statement("If-Else"); }
;

/**
 * Parse a switch-case selection (in BNF-notation).
 *
 *  <case>   ::= case number: { <statements> } end case
 *  <cases>  ::= <case> { <case> }
 *  <switch> ::= switch <arith-expr> <cases> end switch
 *
 */
case: CASE NUMBER COLON statements END CASE
               { print_statement("Case"); }
;
cases: case
|      case cases
;
switch: SWITCH arith_expr cases END SWITCH
               { print_statement("Switch"); }
;

/**
 * Parse a for-loop (in BNF-notation).
 *
 *  <for-loop>           ::= for [ <for-loop-init> ]; [ <for-loop-condition> ]; [ <for-loop_update> ] DO { <statements> } end for
 *  <for-loop-init>      ::= <decl-attrib>
 *  <for-loop-condition> ::= <logic-expr>
 *  <for-loop-update>    ::= <attribution>
 */
for_loop: FOR for_loop_init SEMICOLON for_loop_condition SEMICOLON for_loop_update DO statements END FOR
               { print_statement("For Loop"); }
;
for_loop_init: decl_attrib
|              %empty
;
for_loop_condition: logic_expr
|                   %empty
;
for_loop_update: attribution
|                %empty
;

/**
 * Parse a while-loop (in BNF-notation).
 *
 *  <while-loop> ::= while <logic-expr> do { <statements> } end while
 *
 */
while_loop: WHILE logic_expr DO statements END WHILE
               { print_statement("While Loop"); }
;

/**
 * Parse a do-until-loop (in BNF-notation).
 *
 *  <do-until-loop> ::= do { <statements> } until <logic-expr>
 */
do_until_loop: DO statements UNTIL logic_expr
               { print_statement("Do-Until Loop"); }
;

/**
 * Loop-syntax.
 *
 *  <loop> ::= <for-loop>      |
 *             <while-loop>    |
 *             <do-until-loop>
 */
loop: for_loop
| while_loop
| do_until_loop
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