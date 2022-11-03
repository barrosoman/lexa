
%{
#include <math.h>
    int line_count = 1;

    void print_token(char *name, char *value);
%}

DIGIT          [0-9]
LETTER         [a-zA-Z'_']
ID             {LETTER}({LETTER}|{DIGIT})*
WS             [ \t]
EOL            [\n]
A_OP           "++"|"--"|[+\-\/\*]
ASSIGN         (":="|"*="|"-="|"+="|"/=")
L_OP           ("AND"|"OR"|"!="|">="|"<="|">"|"<"|"=")
PARENTHESIS    ['('')']
BRACKETS       ['\[''\]']
BRACES         ['{''}']
COMMA          (",")
SEMICOLON      (";")
COLON          (":")



%%
{WS}            // Ignore whitespace
{EOL} {
    line_count++;
}
{DIGIT}+{ID} {
    printf("Invalid number (%s) at line %d \n", yytext, line_count);
}
{DIGIT}+ {
    print_token("number", yytext);
}
{L_OP} {
    print_token("l_op", yytext);
}
\".*\" {
    print_token("string", yytext);
}
{ID} {
    print_token("id", yytext);
}
\*+{ID} {
    print_token("pointer", yytext);
}
{A_OP} {
    print_token("a_op", yytext);
}
{SEMICOLON} {
    print_token("semicolon", yytext);
}
{COMMA} {
    print_token("comma", yytext);
}
{PARENTHESIS} {
    print_token("parenthesis", yytext);
}
{BRACKETS} {
    print_token("bracket", yytext);
}
{BRACES} {
    print_token("bracket", yytext);
}
{COLON} {
    print_token("colon", yytext);
}
{ASSIGN} {
    print_token("assign_op", yytext);
}
. {
    printf("Unrecognized character: %s at line %d\n", yytext, line_count);
}

%%

void print_token(char *name, char *value) {
    printf("<%s, %s>\n", name, value);    
}

int main(int argc, char** argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }


    yylex();
    printf("DEBUG: Line_count = %d\n", line_count);
}
