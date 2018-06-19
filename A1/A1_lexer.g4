lexer grammar A1_lexer;

fragment Delim
: ' '
| '\t'
| '\n'
;

fragment Alpha
: [a-zA-Z_]
;

fragment Character
: (.)
;
 
fragment Digit
: [0-9]
;

fragment AlphaNum
: Alpha | Digit
;

fragment HexDigit
: Digit | [a-fA-F]
;

fragment SingleQuote
: '\''
;

fragment DoubleQuote
: '\"'
;

fragment EqOp
: '==' | '!='
;

WhiteSpace
: Delim+ -> skip
;

Char
: (SingleQuote)(Character)?(SingleQuote) | 
(SingleQuote)'\\'(Character)(SingleQuote) 
;

Str
: DoubleQuote~('"')*DoubleQuote
;

Class
: 'class'
;

Program
: 'Program'
;

Void
: 'void'
;

If
: 'if'
;

Else
: 'else'
;

For
: 'for'
;

While
: 'while'
;

Ret
: 'return'
;

Brk
: 'break'
;

Cnt
: 'continue'
;

Callout
: 'callout'
;

Switch
: 'switch'
;

Case
: 'case'
;

Num
: Digit+
;

HexNum
: '0x' HexDigit+
;

BoolLit
: 'true' | 'false'
;

Type
: 'int' | 'boolean'
;

Ident
: Alpha(AlphaNum)*
;

Relop
: '<' | '>' | '<=' | '>=' | EqOp
;

AssignOp
: '=' | '+=' | '-='
;

ArithOp
: '+' | '-' | '*' | '/' | '%'
;

CondOp
: '&&' | '||'
;

OParen
: '('
;

CParen
: ')'
;

OBrace
: '{'
;

CBrace
: '}'
;

OBracket
: '['
;

CBracket
: ']'
;

SemiColon
: ';'
;

Colon
: ':'
;

Comma
: ','
;






