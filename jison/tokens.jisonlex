//// Macros
DIGIT                           [0-9]
NUMBER                          {DIGIT}+(\.{DIGIT}+)?   	// matches: 10 and 3.14
SHORT_NUMBER                    \.{DIGIT}+                  // matches .67

UNICODE							'\\' [0-9a-f]{1,6}(\r\n|[\n\r\t\f])?
ESCAPE							{UNICODE}|'\\'[^\n\r\f0-9a-f]
NL								\n|\r\n|\r|\f
DOUBLE_QUOTE_STRING				'"' ([^\n\r\f\\"]| '\\' {NL}|{ESCAPE})* '"'
SINGLE_QUOTE_STRING				"'" ([^\n\r\f\\']| "\\" {NL}|{ESCAPE})* "'"
STRING							{DOUBLE_QUOTE_STRING}|{SINGLE_QUOTE_STRING}

NAME                            [-a-zA-Z][-\w]*         	// matches: body, background-color, auto and myClassName
BRACKET_NAME                    [-a-zA-Z][-\w\(\)\[\]]*    // matches p:nth-child(odd), audio:not([controls]), etc
SELECTOR                        ((\.|\#|\:\:|\:){BRACKET_NAME})+
                                                            // matches: #id, .class, :hover and ::before
UNIVERSAL						'*'							// matches *, the univeral selector
CHILD							'>'							// matches >, the child combinator
SIBLING							'~'							// matches ~, the sibling combinator
ADJACENT						'+'							// matches +, the adjacent combinator
ATTRIBUTE                       ([\[]{NAME}([\*\^\$~\|]?[=]?({NAME}|{STRING}))[\]])+
                                                            // matches attribute selectors

MEDIA_QUERY                     '@media' ([^@{]+)
IMPORTANT                       '!' [iI][mM][pP][oO][rR][tT][aA][nN][tT]
                                                            // matches !important (case-insensitive - there has to be a better way)

LPAREN                          '('
RPAREN                          ')'
COMMA                           ','
SEMICOLON                       ';'
COLON                           ':'
LBRACE                          '{'
RBRACE                          '}'

%%

//// Rules
'/*'[\s\S]*?'*/'				;							// ignore multiline comments
\s+                             ;                       	// ignore spaces, line breaks

// Numbers
({NUMBER}|{SHORT_NUMBER})(px|em|\%)     return 'DIMENSION';     	// 10px, 1em, 50%, .67em
{NUMBER}|{SHORT_NUMBER}                 return 'NUMBER';        	// 0, .1
\#[0-9A-Fa-f]{3,6}                      return 'COLOR';         	// #fff, #f0f0f0

// strings
{STRING}						        return 'STRING';        	// "blah", 'blah'

// media queries
{MEDIA_QUERY}                           return 'MEDIA_QUERY';       //@media screen and (min-width: 400px) and (max-width: 700px)

// Selectors
{UNIVERSAL}						        return 'SELECTOR';      	// *
{SELECTOR}                              return 'SELECTOR';      	// .class, #id
{NAME}{SELECTOR}                        return 'SELECTOR';      	// div.class, body#id
{NAME}{ATTRIBUTE}{SELECTOR}             return 'SELECTOR';      	// div[rel=external].class
{NAME}{ATTRIBUTE}                       return 'SELECTOR';      	// div[rel=external]
{ATTRIBUTE}                             return 'SELECTOR';      	// div[rel=external]
{CHILD}                			        return 'SELECTOR';      	// >
{SIBLING}                		        return 'SELECTOR';      	// ~
{ADJACENT}                		        return 'SELECTOR';      	// +

{NAME}                                  return 'IDENTIFIER';    	// body, font-size
{IMPORTANT}                             return 'IMPORTANT';

{LPAREN}                          return 'LPAREN';
{RPAREN}                          return 'RPAREN';
{COMMA}                           return 'COMMA';
{SEMICOLON}                       return 'SEMICOLON';
{COLON}                           return 'COLON';
{LBRACE}                            return 'LBRACE';
{RBRACE}                            return 'RBRACE';

.                                       return yytext;          	// {, }, +, :, ;

<<EOF>>                                 return 'EOF';
