all:
	bison -d -b y parser.y
	flex scanner.l
	gcc y.tab.c lex.yy.c -lfl -lm -o prologVars
