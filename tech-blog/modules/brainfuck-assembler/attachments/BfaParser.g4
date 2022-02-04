parser grammar BfaParser;

options { tokenVocab=BfaLexer; }

source
  : dataSection? codeSection
  ;

dataSection
  : DATA_SECTION dataEntry+ DATA_END
  ;

dataEntry
  : VARIABLE_ID ASSIGNMENT (DECIMAL_VALUE | HEX_VALUE | BIN_VALUE)
  ;

codeSection
  : CODE_SECTION instruction+ CODE_END
  ;

instruction
  : MNEMONIC_MOV OPERAND_REG0 OPERAND_DELIM OPERAND_CONST
  | MNEMONIC_MOV OPERAND_REG0 OPERAND_DELIM operandMem
  ;

operandMem
  : MEM_TYPE MEM_MINUS MEM_OFFSET
  ;
