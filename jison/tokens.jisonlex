//// Macros
DIGIT                           [0-9]
NUMBER                          {DIGIT}+(\.{DIGIT}+)?   // matches: 10 and 3.14
NAME                            [a-zA-Z][\w\-]*         // matches: body, background-color, auto and myClassName
SELECTOR                        (\.|\#|\:\:|\:){NAME}   // matches: #id, .class, :hover and ::before
//DOUBLE_QUOTE_STRING             '"' ([^\n\r\f\"])* '"'
//SINGLE_QUOTE_STRING             "'" ([^\n\r\f\"])* "'"


UNICODE							'\\' [0-9a-f]{1,6}(\r\n|[\n\r\t\f])?
ESCAPE							{UNICODE}|'\\'[^\n\r\f0-9a-f]
NL								\n|\r\n|\r|\f
DOUBLE_QUOTE_STRING				'"' ([^\n\r\f\\"]| '\\' {nl}|{escape})* '"'
SINGLE_QUOTE_STRING				"'" ([^\n\r\f\\']| "\\" {nl}|{escape})* "'"
STRING							{DOUBLE_QUOTE_STRING}|{SINGLE_QUOTE_STRING}
%%

//// Rules
'/*'[\s\S]*?'*/'				;						// ignore multiline comments
\s+                             ;                       // ignore spaces, line breaks

// Numbers
{NUMBER}(px|em|\%)              return 'DIMENSION';     // 10px, 1em, 50%
{NUMBER}                        return 'NUMBER';        // 0
\#[0-9A-Fa-f]{3,6}              return 'COLOR';         // #fff, #f0f0f0

// strings
{STRING}
		                        return 'STRING';        // "blah", 'blah'

// Selectors
{SELECTOR}                      return 'SELECTOR';      // .class, #id
{NAME}{SELECTOR}                return 'SELECTOR';      // div.class, body#id

{NAME}                          return 'IDENTIFIER';    // body, font-size

.                               return yytext;          // {, }, +, :, ;

<<EOF>>                         return 'EOF';
