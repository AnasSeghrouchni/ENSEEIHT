
(* The type of tokens. *)

type token = 
  | WHILE
  | TRUE
  | SLASH
  | RETURN
  | RAT
  | PV
  | PT_INT
  | PRINT
  | PO
  | PLUS
  | PF
  | NUM
  | NULL
  | NEW
  | INT
  | INF
  | IF
  | ID of (string)
  | FALSE
  | ESP
  | EQUAL
  | EOF
  | ENTIER of (int)
  | ELSE
  | DP
  | DENOM
  | CROIX
  | CONST
  | CO
  | CF
  | CALL
  | BOOL
  | AO
  | AF

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.AstSyntax.programme)
