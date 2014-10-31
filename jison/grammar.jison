// Jison parser grammar
//
// This file, along with tokens.jisonlex, is compiled to parser.js.
//
// Jison doc: http://zaach.github.io/jison/docs/#specifying-a-language
// Jison is a port of Bison (in C). The format grammar is the same.
// Bison doc: http://dinosaur.compilertools.net/bison/bison_6.html#SEC34
//
// Based on http://www.w3.org/TR/CSS21/syndata.html#syntax

%{
    var ast = require('./ast')
%}

%%

// Parsing starts here.
stylesheet:
  sections EOF                      { return new ast.StyleSheet($1) }
;

sections:
  section                           { $$ = $1 }
| sections section                  { $$ = $1.concat($2) }
;

section:
  media_query                       { $$ = [ $1 ] }
| rule                              { $$ = [ $1 ] }
;

media_query:
  MEDIA_QUERY LBRACE rules RBRACE         { $$ = new ast.MediaQuery($1.trim(), $3) }
;

rules:
  rule                              { $$ = [ $1 ] }
| rules rule                        { $$ = $1.concat($2) }
;

rule:
  selectorList LBRACE properties RBRACE   { $$ = new ast.Rule($1, $3) }
;

selectorList:
  selectors                        { $$ = $1 }
| selectorList COMMA selectors       { $$ = [$1, $3].join(', ') }
;

selectors:
  selector                         { $$ =  $1 }
| selectors selector               { $$ = [$1, $2].join(' ') }
;

selector:
  IDENTIFIER
| SELECTOR
;

properties:
  /* empty */                       { $$ = [] }
| property                          { $$ = [ $1 ] }
| properties SEMICOLON property           { $$ = $1.concat($3) }
| properties SEMICOLON                    { $$ = $1 }
;

property:
  IDENTIFIER COLON values             { $$ = new ast.Property($1, $3) }
| IDENTIFIER COLON values IMPORTANT   { $$ = new ast.Property($1, $3, true) }
;


values:
  value                             { $$ = [ $1 ] }
| values value                      { $$ = $1.concat($2) }
| valueList                         { $$ = new ast.ValueList($1) }
;

valueList:
  value COMMA valueList               { $$ = [ $1 ].concat($3) }
| value COMMA value                   { $$ = [$1, $3] }}
;

value:
  IDENTIFIER LPAREN valueList RPAREN            { $$ = new ast.Function($1, $3) }
| IDENTIFIER                        { $$ = new ast.Literal($1) }
| COLOR                             { $$ = new ast.Literal($1) }
| NUMBER                            { $$ = new ast.Literal($1) }
| DIMENSION                         { $$ = new ast.Literal($1) }
| NAME                              { $$ = new ast.Literal($1) }
| string                            { $$ = new ast.Literal($1) }
;

string:
  STRING
;

functionParams:
;
