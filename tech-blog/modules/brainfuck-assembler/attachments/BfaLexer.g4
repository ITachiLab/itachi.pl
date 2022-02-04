lexer grammar BfaLexer;

DATA_SECTION  : '_data_start' -> pushMode(DATA);
CODE_SECTION  : '_code_start' -> pushMode(CODE);

WS  : [ \r\t\n]+ -> skip;

mode DATA;

VARIABLE_ID   : [a-zA-Z] [a-zA-Z0-9]*;
ASSIGNMENT    : '=';
DECIMAL_VALUE : [0-9]+;
HEX_VALUE     : '0x' [0-9a-fA-F]+;
BIN_VALUE     : '0b' [01]+;
DATA_END      : '_data_end' -> popMode;
DATA_WS       : [ \r\t\n]+ -> skip;

mode CODE;

MNEMONIC_MOV    : 'mov' -> pushMode(INSTRUCTION);
CODE_END        : '_code_end' -> popMode;
CODE_WS         : [ \r\t\n]+ -> skip;

mode INSTRUCTION;

OPERAND_REG0            : 'r0';
OPERAND_CONST           : [0-9]+;
OPERAND_DELIM           : ',';
OPERAND_MEM_DEREF_BEGIN : '[' -> skip, pushMode(MEM_REF);
INSTRUCTION_END         : '\r'?'\n' -> skip, popMode;
INSTRUCTION_WS          : [ \t]+ -> skip;

mode MEM_REF;

MEM_TYPE              : 'sp';
MEM_MINUS             : '-';
MEM_OFFSET            : [0-9]+;
OPERAND_MEM_DEREF_END : ']' -> skip, popMode;
MEM_REF_WS            : [ \r\t\n]+ -> skip;
