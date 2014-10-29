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
  MEDIA_QUERY '{' rules '}'         { $$ = new ast.MediaQuery($1.trim(), $3) }
;

rules:
  rule                              { $$ = [ $1 ] }
| rules rule                        { $$ = $1.concat($2) }
;

rule:
  selectorList '{' properties '}'   { $$ = new ast.Rule($1, $3) }
;

selectorList:
  selectors                        { $$ = $1 }
| selectorList ',' selectors       { $$ = [$1, $3].join(', ') }
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
| properties ';' property           { $$ = $1.concat($3) }
| properties ';'                    { $$ = $1 }
;

property:
  IDENTIFIER ':' values             { $$ = new ast.Property($1, $3) }
| IDENTIFIER ':' values IMPORTANT   { $$ = new ast.Property($1, $3, true) }
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
