(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp
  (* eval : exp -> int *)
  (* Permet d’évaluer la valeur d’une expression. *)
  (* Paramètre : l'expression dont on cherche la valeur *)
  (* Retour : la valeur de l'expression *)
  val eval : exp -> int
end

(* Exercice 4 *)

(* TO DO avec l'aide du fichier  expressionArbreBinaire.txt *)
module ExpAvecArbreBinaire : Expression =
  struct
  (* Type pour représenter les expressions binaires *)
  type op = Moins | Plus | Mult | Div
  type exp = Binaire of exp * op * exp | Entier of int

  (* eval *)
  let rec eval exp =  match exp with
    |Entier a -> a
    |Binaire(exp1,op,exp2) -> match op with
                            |Moins -> (eval exp1) - (eval exp2)
                            |Plus -> (eval exp1) + (eval exp2)
                            |Mult -> (eval exp1) * (eval exp2)
                            |Div -> (eval exp1) / (eval exp2)

  let%test _= eval (Binaire(Entier(1),Plus,Entier(2))) = 3
  let%test _= eval (Binaire(Entier(4),Mult,Entier(2))) = 8
  let%test _= eval (Binaire(Entier(36),Div,Binaire(Entier(4),Mult,Entier(9)))) = 1
  let%test _= eval (Binaire(Entier(42),Moins,Entier(2))) = 40
end

(* Exercice 5 *)

(* TO DO avec l'aide du fichier  expressionArbreNaire.txt *)
module ExpAvecArbreNaire : Expression =
struct

  (* Linéarisation des opérateurs binaire associatif gauche et droit *)
  type op = Moins | Plus | Mult | Div
  type exp = Naire of op * exp list | Valeur of int

  
(* bienformee : exp -> bool *)
(* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
(* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
(* et que les opérateurs de division et soustraction ont exactement deux opéranxpdes.*)
(* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)
let  rec bienformee exp = match exp with
    |Valeur _ -> true
    |Naire(op,exp_liste) -> match op with
                            |Moins -> (List.length exp_liste) = 2 && (List.for_all(bienformee) exp_liste)
                            |Plus -> (List.length exp_liste) >= 2 && (List.for_all(bienformee) exp_liste)
                            |Mult -> (List.length exp_liste) >= 2 && (List.for_all(bienformee) exp_liste)
                            |Div -> (List.length exp_liste) = 2 && (List.for_all(bienformee) exp_liste)


let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
let en2 = Naire (Moins, [ en1; Valeur 5 ])
let en3 = Naire (Mult, [ en1; en2; en1 ])
let en4 = Naire (Div, [ en3; Valeur 2 ])
let en1err = Naire (Plus, [ Valeur 3 ])
let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
let en3err = Naire (Mult, [ en1 ])
let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

let%test _ = bienformee en1
let%test _ = bienformee en2
let%test _ = bienformee en3
let%test _ = bienformee en4
let%test _ = not (bienformee en1err)
let%test _ = not (bienformee en2err)
let%test _ = not (bienformee en3err)
let%test _ = not (bienformee en4err)

(* sum : int list-> int *)
(* Calcule la somme des valeurs d'une liste *)
(* Paramètre : la liste *)
(* Résultat : la somme des termes de la liste *)
let rec sum l = match l with
  | [] -> 0
  | t::q -> t + (sum q)

(* produit : int list-> int *)
(* Calcule le produit des valeurs d'une liste *)
(* Paramètre : la liste *)
(* Résultat : le produit des termes de la liste *)
let rec produit l = match l with
  | [] -> 1
  | t::q -> t*produit q


(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Précondition : l'expression est bien formée *)
(* Résultat : la valeur de l'expression *)
let  rec eval_bienformee exp =  match exp with
|Valeur a -> a
|Naire(op,exp_liste) -> match op with
                        |Moins -> let [terme1;terme2] = exp_liste in (eval_bienformee terme1)-(eval_bienformee terme2)
                        |Plus -> sum (List.map(eval_bienformee) exp_liste)
                        |Mult -> produit (List.map(eval_bienformee) exp_liste)
                        |Div -> let [terme1;terme2] = exp_liste in (eval_bienformee terme1)/(eval_bienformee terme2)

let%test _ = eval_bienformee en1 = 19
let%test _ = eval_bienformee en2 = 14
let%test _ = eval_bienformee en3 = 5054
let%test _ = eval_bienformee en4 = 2527

(* Définition de l'exception Malformee *)
exception Malformee

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Résultat : la valeur de l'expression *)
(* Exception  Malformee si le paramètre est mal formé *)
let eval  exp = if bienformee exp then eval_bienformee exp else
  raise Malformee

let%test _ = eval en1 = 19
let%test _ = eval en2 = 14
let%test _ = eval en3 = 5054
let%test _ = eval en4 = 2527

let%test _ =
  try
    let _ = eval en1err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en2err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en3err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en4err in
    false
  with Malformee -> true

end