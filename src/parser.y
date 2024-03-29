%{
  #include "lexa.h"

  /**
   * It counts the amount of identified syntax errors.
   */
  unsigned int errors = 0;

  extern FILE *yyin;
  extern int yylineno;

  /**
   * It defines the `yyerror` function implementation.
   */
  void yyerror(const char *s) {
    printf("Erro encontrado na linha %d: %s.\n", yylineno, s);
    errors++;
  }

  /**
   * It prints to the standard output that a statement
   * has been recognized by the parser.
   */
  void print_statement(const char *s) {
    printf("O enunciado %s%s%s foi reconhecido.\n", CONSOLE_COLOR_YELLOW, s, CONSOLE_COLOR_RESET);
  }
%}

%expect 2

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
%token ASSIGN_PLUS
%token ASSIGN_MINUS
%token ASSIGN_MUL
%token ASSIGN_DIV

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
%token LBRACKET
%token RBRACKET
%token SEMICOLON
%token COLON
%token COMMA
%token QUESTION_MARK

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
 *  <type>       ::= void | bool | char | short | int | float | long | double | <type-array>;
 *  <type-array> ::= <type> []
 */
type: VOID
|     BOOL
|     CHAR
|     SHORT
|     INTEGER
|     FLOAT
|     LONG
|     DOUBLE
|     type_array
;
type_array: type LBRACKET RBRACKET
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
 *  <procedure-args> ::= <expr> { , <expr> }
 *
 */
procedure_call: ID LPAREN procedure_args RPAREN
               { print_statement("Procedure Call"); }
;
procedure_args: expr
|               expr COMMA procedure_args
|               %empty
;

/**
 * Parsing a return statement (in BNF-notation).
 *
 *  <return-statement> ::= return <expr>
 *
 */
return_statement: RETURN expr
;

/**
 * Parsing an expression (in BNF-notation).
 * 
 *  <expr> ::= string         |
 *             character      |
 *             <logical-expr> |
 *             <ternary>      |
 *             ( <expr> )
 *
 */
expr: STRING 
| CHARACTER 
| logical_expr 
| ternary
| LPAREN expr RPAREN
;

/**
 * Parsing the ternary-operator (in BNF-notation).
 *
 *  <ternary> ::= <logical-expr> ? <expr> : <expr>
 *
 */
ternary: logical_expr QUESTION_MARK expr COLON expr;

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
 *  <arith-factor> ::= id                  |
 *                     id [ <arith-expr> ] |
 *                     + id                |
 *                     - id                |
 *                     number              |
 *                     + number            |
 *                     - number            |
 *                     <procedure-call>    |
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
|             ID LBRACKET arith_expr RBRACKET /* Array indexing */
|             PLUS ID       /* Unary plus operator  */
|             MINUS ID      /* Unary minus operator */
|             NUMBER
|             PLUS NUMBER   /* Unary plus operator  */
|             MINUS NUMBER  /* Unary minus operator */
|             procedure_call
|             LPAREN arith_expr RPAREN
;

/**
 * Parse a logicalal expression (in BNF-notation).
 *
 * The productions provided for this logicalal expressions
 * already provides higher precedence for NOT, followed
 * by AND and followed by OR.
 *
 *  <logical-expr>   ::= <logical-expr> or <logical-term> |
 *                       <logical-term>
 *  <logical-term>   ::= <logical-term> and <logical-factor> |
 *                       <logical-factor>
 *  <logical-factor> ::= not <logical-factor> |
 *                       ( <logical-expr> )   |
 *                       true                 | 
 *                       false                |
 *                       <comp-expr>
 */
logical_expr: logical_expr OR logical_term
|           logical_term
;
logical_term: logical_term AND logical_factor
|           logical_factor
;
logical_factor: NOT logical_factor
|             LPAREN logical_expr RPAREN
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
 *  <attribution> ::= id = <expr>  |
 *                    id += <expr> |
 *                    id -= <expr> |
 *                    id *= <expr> |
 *                    id /= <expr> |
 *                    id++         |
 *                    id--         |
 *                    ++id         |
 *                    --id
 *
 */
attribution: ID ASSIGN expr       /* Assignment operator              */ 
|            ID ASSIGN_PLUS expr  /* Addition assignment operator     */
|            ID ASSIGN_MINUS expr /* Subtraction assignmewnt operator */
|            ID ASSIGN_MUL expr   /* Multiply assignment operator     */
|            ID ASSIGN_DIV expr   /* Divide assignment operator       */
|            ID PLUS PLUS         /* Increment postfix operator       */
|            ID MINUS MINUS       /* Decrement postfix operator       */
|            PLUS PLUS ID         /* Increment prefix operator        */
|            MINUS MINUS ID       /* Decrement prefix operator        */
;

/**
 * Parse a declaration with attribution (in BNF-notation).
 *
 *   <decl-attrib-post-let> ::= id: <type> = <expr> { , <decl-attrib-post-let> }
 *   <decl-attrib>          ::= let <decl-attrib-post-let>
 *
 */
decl_attrib_post_let: ID COLON type ASSIGN expr
|                     ID COLON type ASSIGN expr COMMA decl_attrib_post_let
               { print_statement("Declaration"); }
;
decl_attrib: LET decl_attrib_post_let
               { print_statement("Declaration"); }
;

/**
 * Parse a if-then-else condition (in BNF-notation).
 *
 *  <conditional> ::= if <logical-expr> then { <statements> } end if |
 *                ::= if <logical-expr> then { <statements> } else { <statements >} end if
 *
 */
conditional: IF logical_expr THEN statements END IF
               { print_statement("If"); }
|            IF logical_expr THEN statements ELSE statements END IF
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
 *  <for-loop-condition> ::= <logical-expr>
 *  <for-loop-update>    ::= <attribution>
 */
for_loop: FOR for_loop_init SEMICOLON for_loop_condition SEMICOLON for_loop_update DO statements END FOR
               { print_statement("For-Loop"); }
;
for_loop_init: decl_attrib
|              %empty
;
for_loop_condition: logical_expr
|                   %empty
;
for_loop_update: attribution
|                %empty
;

/**
 * Parse a while-loop (in BNF-notation).
 *
 *  <while-loop> ::= while <logical-expr> do { <statements> } end while
 *
 */
while_loop: WHILE logical_expr DO statements END WHILE
               { print_statement("While-Loop"); }
;

/**
 * Parse a do-until-loop (in BNF-notation).
 *
 *  <do-until-loop> ::= do { <statements> } until <logical-expr> ;
 */
do_until_loop: DO statements UNTIL logical_expr SEMICOLON
               { print_statement("Do-Until-Loop"); }
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

  /* It checks if some syntax error has been found */
  /* while the file was being parsed */
  if (errors == 0) {
    printf("Nenhum erro sintático foi encontrado durante a análise sintática!\n");
  }
}
