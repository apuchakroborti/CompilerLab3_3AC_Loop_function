yacc -d ass.y
flex ass.l
gcc lex.yy.c y.tab.c -ll -lm 
./a.out
