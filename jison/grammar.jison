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
  rules EOF                         { return new ast.StyleSheet($1) }
;

rules:
  rule                              { $$ = [ $1 ] }
| rules rule                        { $$ = $1.concat($2) }
;

rule:
  selectors '{' properties '}'     { $$ = new ast.Rule($1, $3) }
;

selectors:
  selector                         { $$ =  $1 }
| selectors selector               { $$ = [$1, $2].join(' ') }
| selectors                        { $$ = $1 }
;

selector:
  IDENTIFIER
| SELECTOR
;

properties:
  /* empty */                       { $$ = [] }
| property                          { $$ = [ $1 ] }
| properties ';' property           { $$ = $1.concat($3) }
| properties ';'                    { $$ = $1 }
;

property:
  IDENTIFIER ':' values             { $$ = new ast.Property($1, $3) }
;


values:
  value                             { $$ = [ $1 ] }
| values value                      { $$ = $1.concat($2) }
| valueList                         { $$ = new ast.ValueList($1) }
;

valueList:
  value ',' valueList               { $$ = [ $1 ].concat($3) }
| value ',' value                   { $$ = [$1, $3] }}
;

value:
  IDENTIFIER                        { $$ = new ast.Literal($1) }
| COLOR                             { $$ = new ast.Literal($1) }
| NUMBER                            { $$ = new ast.Literal($1) }
| DIMENSION                         { $$ = new ast.Literal($1) }
| NAME                              { $$ = new ast.Literal($1) }
| string                            { $$ = new ast.Literal($1) }
;

string:
  STRING
;

