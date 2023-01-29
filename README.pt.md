# Lexa
## :fountain_pen: Sobre
**Lexa** *(pronuncia-se, lécsa)* é um analisador sintático criado utilizando as ferramentas `flex` e `bison`. Isto posto, a gramática do **Lexa** é inspirada nos estilos das linguagens de programção **TypeScript**, **Pascal** e **Rust** mas também adiciona algumas peculiaridades.

## 🎓 Um projeto de universidade
O projeto de um analisador léxico e sintático **Lexer** é um requisito da disciplina de **Compiladores**.

## :book: Introdução
**Lexa** pode ser usado por iniciantes para guiar de maneira mais **simples** e **direta** no uso das ferramentas **flex** e **bison** para a criação de analisadores léxicos e sintáticos, respectivamente.

Alem disso, a interação entre o usuário é o programa é **fácil**, **conveniente** e **simples**, de modo que, o programa prime na saída padrão as regras gramaticais que foram reconhecidas e imprime ao final da execução do programa se a entrada é válida segundo a gramática do **Lexa**.

#### :question: **O que é um analisador léxico?**
Um **analisador léxico** ou **lexer**) é um dos primeiros analisadores no processo de compilação (geralmente, o primeiro) no qual uma **sequência de caracteres** e dada como entrada e uma **sequência de tokens** e dada como saída. 

Por fim, pode ser dito que a **sequência de tokens** dada com saída é a entrada da próxima etapa no processo de compilação, neste caso, a próxima etapa é o analisador sintático também chamado de **parser**.

#### :question: **O que é um analisador sintático?**
Um **analisador sintático** (ou **parser**) é um dos analisadores no processo de compilação (geralmente, o segundo) no qual uma **sequência de tokens** é dada como entrada e uma **arvoré sintática abstrata** é dada como saída. Em alguns processos de compilação as expressões podem ser diretamente avaliadas no momento do analisador sintatico, de modo que, a árvore sintática absttrata não é necessariamente produzida.

Além disso, pode ser dito que a **árvore sintática abstrata** dada como saída é a entrada da próxima etapa no processo de compilação isto é, geralmente, o analisador semântico. Neste projeto, o analisador semântico não foi implementado.

## :hammer_and_wrench: Compilação
Primeiro de tudo, o analisador deve ser compilado primeiro. Portanto, sugerimos que siga as próximas etapas.

#### 1. Instalando o gcc.
Instale o *gcc*, o compilador **C**, executando a seguinte linha.
<p align="center"><i>sudo apt install gcc</i></p>

:bell: **Nota**: Se você já possui o *gcc* instalado, então você pode pular para o próximo passo.

#### 2. Instalando o make.
Instalar o *make* facilita a compilação de nosso simulator possibiltando compilar o projeto inteiro usando somente um comando.

<p align="center"><i>sudo apt install make</i></p>

:bell: **Nota**: Se você já possui o *make* instalado, então você pode pular para o próximo passo.

#### 3. Compilando o analisador (usando make).
Execute a seguinte linha para compilar o analisador (usando make)

<p align="center"><i>make</i></p>

:bell: **Nota**: Se você não possui o *make* instalado, então você pode pular para a próxima etapa. Caso contrário, você pode pular para a próxima seção.

#### 3. Compilando o analisador (sem make).
Execute a seguinte linha para compilar o analisador (sem make)

<p align="center"><i>bison --header=src/parser.h -o src/parser.c src/parser.y</i></p>
<p align="center"><i>flex -o src/scanner.c src/scanner.l</i></p>
<p align="center"><i>gcc -o lexa src/parser.c src/scanner.c</i></p>

## :rocket: Executando
Se você já seguiu os passos fornecidos na execução anterior, então você está pronto para executar nosso analisador.

<p align="center"><i>./lexa {arquivo}</i></p>

na qual **{arquivo}** é o nome do arquivo de entrada sem **{** e **}**.

Após isso, divirta-se!
