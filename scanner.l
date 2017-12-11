%{
#define YYSTYPE char *
#include "y.tab.h"
#include <stdio.h>
%}
%%
\. {return dot;}
:- {return def;}
, {return com;}
[0-9]+(\.[0-9]+)? {return num;}
[a-z][a-z0-9]* {return id;}
[A-Z][A-Za-z0-9]* {yylval = yytext; return var;}
\( {return opa;}
\) {return cpa;}
\[ {return obr;}
\] {return cbr;}
\| {return pipeline;}
[ ]+ ;
. { printf("Can't interpret %s\n", yytext); }

