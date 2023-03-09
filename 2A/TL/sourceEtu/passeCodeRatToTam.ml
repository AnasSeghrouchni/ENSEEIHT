(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type
open Tam
open Code

type t1 = Ast.AstPlacement.programme
type t2 = string

let rec analyse_code_affectable a =
  match a with
  | AstType.Ident(infoa) ->  
    begin
    match info_ast_to_info infoa with
          |InfoConst(_,v) -> loadl_int v
          |InfoVar(_,t,d,r) -> load (Type.getTaille t) d r
          |_ -> assert false
    end
  | AstType.Dereference a -> failwith "je sais pas"
    
let rec analyse_code_expression e =
  match e with
  | AstType.AppelFonction(infoa, le) ->begin 
    match info_ast_to_info infoa with
    |InfoFun(n,t,lt) -> String.concat " " (List.map(analyse_code_expression) le)^call "ST" n
    |_ -> failwith "impossible"
    end
  | AstType.Booleen(b) -> if b then loadl_int 1 else loadl_int 0
  | AstType.Entier(i) -> loadl_int i
  | AstType.Unaire(op, e) -> begin match op with
    | Numerateur -> (analyse_code_expression e ) ^ (pop 0 1)
    | Denominateur -> (analyse_code_expression e) ^ (pop 1 1)
                    end
  | AstType.Binaire(op, e1, e2) -> (analyse_code_expression e1) ^ (analyse_code_expression e2 ) ^
          begin 
            match op with
            |Fraction -> call "ST" "norm"
            |PlusInt -> subr "IAdd"
            |PlusRat -> call "ST" "radd"
            |MultInt -> subr "IMul"
            |MultRat -> call "ST" "rmul"
            |EquInt -> subr "IEq"
            |EquBool -> subr "IEq"
            |Inf -> subr "ILss"
          end
  | AstType.Affectable(a) -> analyse_code_affectable a
  | AstType.Null -> loadl_int 0
  | AstType.Adresse ia -> 
    begin
     match info_ast_to_info ia with
          |InfoVar(_,_,d,r) -> loada d r
          |_ -> assert false
    end
  | AstType.New t -> let taille = getTaille t in
    loadl_int taille
    ^ subr "MAlloc"
  | AstType.Ternaire(e1,e2,e3) -> let etiqelse = Code.getEtiquette () in let etiqfin = Code.getEtiquette () in
                                          analyse_code_expression e1 ^
                                          jumpif 0 etiqelse ^
                                          (analyse_code_expression e2) ^
                                          jump etiqfin ^
                                          label etiqelse ^
                                          (analyse_code_expression e3) ^
                                          label etiqfin

  


let rec analyse_code_instruction i = 
  match i with
  | AstPlacement.Declaration(infoa,e) -> 
      begin match info_ast_to_info infoa with
      |InfoVar(_,t,d,r) -> (push (getTaille t)) ^ (analyse_code_expression e) ^  (store (getTaille t) d r)
      |_ -> assert false
  end
  | AstPlacement.Affectation(a,e) -> (analyse_code_expression e)^(analyse_code_affectable a) 
  | AstPlacement.AffichageInt(e) -> (analyse_code_expression e) ^ subr "IOut"
  | AstPlacement.AffichageRat(e) -> (analyse_code_expression e) ^ call "ST" "rout"
  | AstPlacement.AffichageBool(e) -> (analyse_code_expression e) ^ subr "BOut"
  | AstPlacement.Conditionnelle(e,b1,b2) -> let etiqelse = Code.getEtiquette () in let etiqfin = Code.getEtiquette () in
                                          analyse_code_expression e ^
                                          jumpif 0 etiqelse ^
                                          (analyse_code_bloc b1) ^
                                          jump etiqfin ^
                                          label etiqelse ^
                                          (analyse_code_bloc b2) ^
                                          label etiqfin 
  | AstPlacement.TantQue(e,b) -> let etiqbloucle = Code.getEtiquette () in let etiqfin = Code.getEtiquette () in
                                          label etiqbloucle ^
                                          analyse_code_expression e ^
                                          jumpif 0 etiqfin ^
                                          analyse_code_bloc b ^
                                          jump etiqbloucle ^
                                          label etiqfin 
  | AstPlacement.Retour(e,i1,i2) ->  analyse_code_expression e^return i1 i2^pop (i1) i2
  | AstPlacement.Empty -> ""

  and analyse_code_bloc (li,taille_var_locales) =
  (String.concat " " (List.map (analyse_code_instruction) li) ) ^ (pop 0 taille_var_locales)


let analyse_code_fonction (AstPlacement.Fonction(infoa, _, bloc)) =
   match info_ast_to_info infoa with
   | InfoFun(n,t,lt) -> label n^analyse_code_bloc bloc^halt
   | _-> failwith "Une fonction est attendue"


let analyser (AstPlacement.Programme (fonctions,prog)) =
  Code.getEntete  ()^
  (String.concat " " (List.map (analyse_code_fonction) fonctions))^
  label "main"^
  analyse_code_bloc prog ^
  halt