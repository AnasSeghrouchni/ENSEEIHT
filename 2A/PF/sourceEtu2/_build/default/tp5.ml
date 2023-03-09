(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end


(*Module convertissant en chaine de characteres*)
module PrintSimple : ExprSimple with type t = string =
struct
    type t = string
    let const c = string_of_int c
    let plus e1 e2 = "("^e1^"+"^e2^")"
    let mult e1 e2 = "("^e1^"*"^e2^")"
end

(*Module convertissant en chaine de characteres*)
module CompteSimple : ExprSimple with type t = int =
struct
    type t = int
    let const _ = 0
    let plus e1 e2 = 1+e1+e2
    let mult e1 e2 = 1+e1+e2
end


(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)
module EvalExemplesChar =  ExemplesSimples (PrintSimple)
module EvalExemplesCompt = ExemplesSimples (CompteSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

let%test _ = (EvalExemplesChar.exemple1 = "(1+(2*3))")
let%test _ = (EvalExemplesChar.exemple2 = "((5+2)*(2*3))")

let%test _ = (EvalExemplesCompt.exemple1 = 2)
let%test _ = (EvalExemplesCompt.exemple2 = 3)

(* Module abstrayant les expressions avec variables *)
module type ExprVar =
sig
  type t
  val var : string -> t
  val def : string*t -> t  -> t
end

module type Expr =
sig
  type a
  include ExprSimple with type t = a
  include ExprVar with type t = a
end

module PrintVar : ExprVar with type t = string =
struct
    type t = string
    let var c = c
    let def (n,i) e = "let "^n^" = "^i^" in "^e
end

module Print : Expr with type a = string =
struct
  type a = string
  include PrintSimple
  include PrintVar  
end 

(* Définition des expressions *)
module Exemples (E:Expr) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )

  let exemple3 = E.(def ("x", (plus (const 1) (const 2))) (mult (var "x") (const 3)))

end

module EvalExemplesFinale = Exemples (Print)
(* Module d'évaluation des exemples *)
let%test _ = (EvalExemplesFinale.exemple1 = "(1+(2*3))")
let%test _ = (EvalExemplesFinale.exemple2 = "((5+2)*(2*3))")
let%test _ = (EvalExemplesFinale.exemple3 = "let x = 1+2 in x*3")