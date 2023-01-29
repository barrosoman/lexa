##### Troque para [Português Brasileiro](./README.pt.md) 🇧🇷.

# Lexa
## :fountain_pen: About
**Lexa** is a parser created on top of `flex` and `bison`. Further, the **Lexa** grammar adopts its styles from programming languages like **TypeScript**, **Pascal** and **Rust** but also add its peculiarities.

## 🎓 A college Project
**Lexa** parser project is a requirement for the **Compilers** course.

## :book: Brief
**Lexa** can be use to guide beginners in the use of **flex** and **bison** tools for making lexical and syntax analyzers, respectively.

Further, the interaction between the user and the program is **easy**, **convenient** and **simple**, such that, the program prints out the grammar rules that are valid and prints at the end of the execution if the input is valid with relation to the **Lexa**'s grammar.

#### :question: **What is a lexical analyzer?**
A **lexical analyzer** (or **lexer**) is one of the analyzers in the compiling process (generally, the first) in which a **sequence of characters** is taken as input and a **sequence of token** is given as output. 

Further, it can be said that the **sequence of tokens** given as output is the input of the next step in the compiling process, in this case, the next step is the syntax analyzer or also called **parser**.

#### :question: **What is a syntax analyzer?**
A **syntax analyzer** (or **parser**) is one of the analyzers in the compiling process (generally, the second) in which a **sequence of tokens** is taken as input and an **abstract syntax tree** is given as output. In some compiling process the result may be directly evaluated at the parser, such that, the abstract syntax tree is not necessarily produced.

Further, it can be said that the **abstract syntax tree** given as output is the input of the next step in the compiling process that is, generally, the semantic analyzer. In this project, a semantic analyzer is not implemented.

## :hammer_and_wrench: Compiling
First things first, the parser must be compiled first. Therefore, we suggest to follow the next steps.

#### 1. Installing the gcc.
Install the *gcc* the **C** compiler executing the following line.
<p align="center"><i>sudo apt install gcc</i></p>

:bell: **Note**: If you already have the *gcc* installed, then you can jump to the next step.

#### 2. Installing the make.
Install the *make* easies the compilation of our simulator enabling compile the entire project using just one command.

<p align="center"><i>sudo apt install make</i></p>

:bell: **Note**: If you already have the *make* installed, then you can jump to the next step. Further, if you do not want to use make then you can jump the next step.

#### 3. Compiling the parser (using make).
Execute the following line to compile the parser (using make)

<p align="center"><i>make</i></p>

:bell: **Note**: If you do not have the *make* installed, then you can jump to the next step. Otherwise, you can jump to the next section.

#### 3. Compiling the parser (without make).
Execute the following line to compile the parser (without make)

<p align="center"><i>bison --header=src/parser.h -o src/parser.c src/parser.y</i></p>
<p align="center"><i>flex -o src/scanner.c src/scanner.l</i></p>
<p align="center"><i>gcc -o lexa src/parser.c src/scanner.c</i></p>

## :rocket: Running
If you already followed the steps provided in the previous section, then you are ready to run our parser, for that run the following line.

<p align="center"><i>./lexa {input}</i></p>

in which **<input>** is the input file name without the **{** and **}**.

After that, have fun!
