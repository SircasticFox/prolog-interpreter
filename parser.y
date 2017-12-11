%{
#include "y.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
void yyerror(char *);

struct listItem{
  char * ident;
  struct listItem *next;
};

struct listItem *createListItem(char * id){
  //Allocate space for new List Item
  struct listItem * newItem = malloc(sizeof(struct listItem));
  //Since it's an own Item it doesn't point to any other Element at this point
  newItem->next = NULL;
  //Allocates space for saving the name
  newItem->ident = malloc((strlen(id) + 1) * sizeof(char));
  //Saves Name in ListItem
  strcpy(newItem->ident, id);
  return newItem;
}

struct listItem *mergeList(struct listItem *list1, struct listItem *list2){
  //If list1 is empty, just return list2
  if(list1 == NULL){
    return list2;
  }
  //If list2 is empty, just return list1
  if(list2 == NULL){
    return list1;
  }

  //Cache for list1 pointer
  struct listItem * pointerCache = list1;

  //Iterate to last LinkedList Item from list1
  while(list1->next != NULL){
    list1 = list1->next;
  }

  //Traverses through list2 and appends its items to list1
  while(list2 != NULL){
    //Check for occurence of the Identifier
    //Only merge to other list if it doesn't exist yet
    if(hasElement(pointerCache,list2->ident) == 0){
      //Append Item from list2 to list1
      list1->next = list2;
      //Go to just added item in list1
      list1 = list1->next;
      //Go to next item of list2
      list2 = list2->next;
      //Remove possible pointers to the next element
      list1->next = NULL;
    }
    else {
      //Go to next item of list2
      list2 = list2->next;
    }
  }

  //Return pointer of first element from list1
  return pointerCache;
}

//Checks if list contains Identifier already
int hasElement(struct listItem *list, char * id){
  //Iterate through list and check if any element is the id
  while(list != NULL){
    //Compare Identifier
    if(strcmp(id,list->ident)==0){
      return 1;
    }
    //go to the next element
    list = list->next;
  } 

  return 0;
}

void printVar(struct listItem *v){
  printf("Vars: ");
  //Traverse through LinkedList
  while(v != NULL){
    //Print Variable Identifier
    if(v->next != NULL) {
      //Print with comma afterwards, one or more items following
      printf("%s, ", v->ident);
    }
    else {
      //Print without comma afterwards, last item
      printf("%s", v->ident);
    }
    
    v = v->next;
  }
  printf("\n");
}

%}
%union {
  struct listItem *nt;
  char *t;
}
%token <t> dot def com num id var obr cbr pipeline opa cpa
%type <nt> FACT RULE TERM TERML LIST LITERAL LITERALL
%start SL

%%
SL: S SL {;}
  | S {;};

S: FACT {printVar($1);}
 | RULE {printVar($1);};

FACT: LITERAL dot {$$ = $1;};

RULE: LITERAL def LITERALL dot { $$ = mergeList($1, $3);};

LITERAL: id opa TERML cpa {$$ = $3;}
       | var {$$ = createListItem($1);};

LITERALL: LITERAL com LITERALL {$$ = mergeList($1, $3);}
        | LITERAL {$$ = $1;};

TERML: TERM com TERML { $$ = mergeList($1, $3);}
	   | TERM {$$ = $1;};

TERM: num {$$ = NULL;}
    | id {$$ = NULL;}
    | id opa TERML cpa {$$ = $3;}
    | LIST {$$ = $1;};

LIST: obr cbr {$$ = NULL;}
    | obr TERML cbr {$$ = $2;}
    | obr TERML pipeline LIST cbr {$$ = mergeList($2, $4);}
    | var {$$ = createListItem($1);};
%%

int main(void){
  yyparse();
  return 0;
}

void yyerror(char *message){
  printf("%s\n", message);
}