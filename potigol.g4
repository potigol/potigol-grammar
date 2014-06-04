grammar potigol;

// Parser
prog:  inst (NL* inst)* ;

inst: decl | expr | cmd;

cmd : 'escreva' expr      # escreva
    | 'imprima' expr      # imprima
    | id1 ':=' expr     # atrib_simples
    | id2 ':=' expr2    # atrib_multipla
    | expr'['expr']' ('='|':=') expr  # set_vetor
    ;

decl: decl_valor | decl_funcao | decl_tipo ;

decl_valor:
      id1 '=' expr                    # valor_simples
    | id2 '=' expr2                   # valor_multiplo
    | 'var' id1 (':='| '=') expr      # decl_var_simples
    | 'var' id2 (':='| '=') expr2     # decl_var_multipla
    ;

decl_funcao:
      ID '(' dcls ')' (':' tipo)? '=' expr        # def_funcao
    | ID '(' dcls ')' (':' tipo)? exprlist 'fim'  # def_funcao_corpo
    ;

decl_tipo:
      'tipo' ID '=' tipo                    # alias
    | 'tipo' ID (dcl|decl_funcao)+ 'fim'      # classe
    ;

dcl: id1 ':' tipo ;
dcls: (dcl (',' dcl)* )? ;

dcl1: ID
    | '(' expr2 ')'
    | '(' dcls ')'
    ;

tipo: ID                                # tipo_simples
    | '(' tipo2 ')'                     # tipo_tupla
    | ID '[' tipo ']'                   # tipo_generico
    | tipo '=>' tipo                    # tipo_funcao
    ;

expr:
      ID                                  # id
    | STRING                              # texto
    | INT                                 # inteiro
    | FLOAT                               # real
    | CHAR                                # char
    | expr '.' ID ('(' expr1 ')')?        # chamada_metodo
    | expr '(' expr1? ')'                 # chamada_funcao
    | expr '[' expr ']'                   # get_vetor
    | expr '^'<assoc=right> expr          # expoente
    | expr '::'<assoc=right> expr         # cons
    | expr 'formato' expr                 # formato
    | ('+'|'-') expr                      # mais_menos_unario
    | expr ('*'|'/'|'mod') expr           # mult_div
    | expr ('+'|'-') expr                 # soma_sub
    | expr ('>'|'>='|'<'|'<='|'=='|'<>') expr   # comparacao
    | ('nao'|'n\u00e3o') expr             # nao_logico
    | expr 'e' expr                       # e_logico
    | expr 'ou' expr                      # ou_logico
    | dcl1 '=>' ( inst (NL* inst)*)       # lambda
    | 'se' expr ('entao'|'ent\u00e3o')?
        exprlist
      (('senaose'|'sen\u00e3ose') expr ('entao'|'ent\u00e3o')?
        exprlist)*
      (('senao'|'sen\u00e3o')
        exprlist)?
      'fim'                               # se
    | 'para' faixas ('se' expr)? ('faca'|'fa\u00e7a')?
        exprlist
      'fim'                               # para_faca
    | 'para' faixas ('se' expr)? 'gere'
        exprlist
      'fim'                              # para_gere
    | 'enquanto' expr ('faca'|'fa\u00e7a')?
        exprlist
      'fim'                               # enquanto
    | 'escolha' expr
        caso+
      'fim'                               # escolha
    | '(' expr ')'                      # paren
    | '(' expr2 ')'                     # tupla
    | '[' (expr1)? ']'                  # lista
    | 'verdadeiro'                        # verdadeiro
    | 'falso'                             # falso
    ;

caso: 'caso' expr ('se' expr)? '=>' exprlist;

faixa: ID 'em' expr
     | ID 'de' expr ('ate'|'at\u00e9') expr ('passo' expr)?
     ;

faixas: faixa (',' faixa)*;

expr1: expr (',' expr)* ;
expr2: expr (',' expr)+ ;
id1 : ID (',' ID)* ;
id2 : ID (',' ID)+ ;

tipo2 : tipo (',' tipo)+ ;

exprlist: (NL* inst)* ;

// Lexer
ID: (ALPHA|ACENTO) (ALPHA|ACENTO|DIGIT)* ;

fragment
ALPHA: 'a' .. 'z' | 'A' .. 'Z'| '_' ;
fragment
ACENTO : '\u00a1' .. '\ufffc' ;

INT : DIGIT+ ;

FLOAT
    : DIGIT+ '.' DIGIT*
    |        '.' DIGIT+
    ;
fragment
DIGIT: '0'..'9' ;

STRING : '"' (ESC | .) *? '"' ;
CHAR : '\''.'\'';

fragment
ESC : '\\"' | '\\\\' ;

COMMENT : '#' .*? '\r'? '\n' -> skip ;
WS : (' '|'\t'|'\r'|'\n')+ -> skip ;

NL : '\r\n' | '\n' ;
