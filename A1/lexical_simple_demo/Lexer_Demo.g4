lexer grammar Lexer_Demo;

fragment Delim
: ' '
| '\t'
| '\n'
;

fragment Letter
: [a-zA-Z]
;

fragment Digit
: [0-9]
;

WhiteSpace
: Delim+ -> skip
;

Num
: Digit+
;

String
: Letter+
;


SemiColon
: ';'
;







