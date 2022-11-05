
%{
#include <math.h>
    int line_count = 1;

    void print_token(const char *name, const char *value);
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
FOR            for
WHILE          while
SWITCH         switch
CASE           case
BREAK          break

%%
{WS}            // Ignore whitespace
{EOL} {
    line_count++;
}
{BOOL}    { print_token("bool", yytext); }
{CHAR}    { print_token("char", yytext); }
{SHORT}   { print_token("short", yytext); }
{INTEGER} { print_token("integer", yytext); }
{FLOAT}   { print_token("float", yytext); }
{LONG}    { print_token("long", yytext); }
{DOUBLE}  { print_token("double", yytext); }
{RETURN}  { print_token("return", yytext); }
{CONST}   { print_token("const", yytext); }
{IF}      { print_token("if", yytext); }
{FOR}     { print_token("for", yytext); }
{WHILE}   { print_token("while", yytext); }
{SWITCH}  { print_token("switch", yytext); }
{CASE}    { print_token("case", yytext); }
{BREAK}   { print_token("break", yytext); }
{LBRACE}  { print_token("lbrace", yytext); }
{RBRACE}  { print_token("rbrace", yytext); }
{NUMBER} {
    print_token("number", yytext);
}
{DIGIT}+{ID} {
    printf("Invalid number (%s) at line %d \n", yytext, line_count);
}
{AND}        { print_token("and", yytext); }
{OR}         { print_token("or", yytext); }
{EQUAL}      { print_token("equal", yytext); }
{NOT_EQUAL}  { print_token("not_equal", yytext); }
{LT}         { print_token("lt", yytext); }
{LTE}        { print_token("lte", yytext); }
{GT}         { print_token("gt", yytext); }
{GTE}        { print_token("gte", yytext); }
\".*\" {
    print_token("string", yytext);
}
{ID} {
    print_token("id", yytext);
}
\*+{ID} {
    print_token("pointer", yytext);
}
{ASSIGN}      { print_token("assign", yytext); }
{PLUS}        { print_token("plus", yytext); }
{MINUS}       { print_token("minus", yytext); }
{MUL}         { print_token("mul", yytext); }
{DIV}         { print_token("div", yytext); }
{PLUS_EQUAL}  { print_token("plus_equal", yytext); }
{MINUS_EQUAL} { print_token("minus_equal", yytext); }
{MUL_EQUAL}   { print_token("mul_equal", yytext); }
{DIV_EQUAL}   { print_token("div_equal", yytext); }
{SEMICOLON} {
    print_token("semicolon", yytext);
}
{COMMA} {
    print_token("comma", yytext);
}
{LPAREN}   { print_token("lparen", yytext); }
{RPAREN}   { print_token("rparen", yytext); }
{LBRACKET} { print_token("lbracket", yytext); }
{RBRACKET} { print_token("rbracket", yytext); }
{COLON} {
    print_token("colon", yytext);
}
. {
    printf("Unrecognized character: %s at line %d\n", yytext, line_count);
}

%%

void print_token(const char *name, const char *value) {
    printf("<%s, %s>\n", name, value);    
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }


    yylex();
    printf("DEBUG: Line_count = %d\n", line_count);
}
