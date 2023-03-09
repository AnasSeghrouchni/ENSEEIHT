(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

(* analyse_placement_instruction : int -> string -> AstTds.instruction -> AstPlacement.instruction*int *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des type et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_placement_instruction dep reg i =
  match i with
  | AstType.Declaration(infoa,e) -> 
    begin  
      match info_ast_to_info infoa with 
                                      | InfoVar(_,t,_,_) ->  modifier_adresse_variable dep reg infoa; (AstPlacement.Declaration(infoa, e), (Type.getTaille t))
                                      | _ -> failwith "Une variable est attendue"
    end
  | AstType.Affectation (a,e) -> (AstPlacement.Affectation(a,e),0)
  | AstType.AffichageInt ne -> (AstPlacement.AffichageInt ne, 0)
  | AstType.AffichageRat ne -> (AstPlacement.AffichageRat ne, 0)
  | AstType.AffichageBool ne -> (AstPlacement.AffichageBool ne, 0)
  | AstType.Conditionnelle (b,x1,x2) -> (AstPlacement.Conditionnelle(b, analyse_placement_bloc dep reg x1, analyse_placement_bloc dep reg x2), 0)
  | AstType.TantQue (nc,bast) -> (AstPlacement.TantQue(nc, analyse_placement_bloc dep reg bast), 0)
  | AstType.Retour (e,infoa) -> 
    begin
      match info_ast_to_info infoa with
      |  InfoFun(_, t, lt) -> (AstPlacement.Retour(e, (Type.getTaille t), (List.fold_right (+) (List.map (Type.getTaille) lt) 0)), 0)
      | _ -> failwith "Une fonction est attendue"
    end
  | AstType.Empty ->  AstPlacement.Empty,0

(* analyse_tds_bloc :  AstType.bloc -> AstPlacement.bloc *)
and analyse_placement_bloc dep reg b =
   let rec placement_i dep reg b = match b with
    |[] -> [],0
    |t::q -> let (a,b) = analyse_placement_instruction dep reg t in let (l,d) = placement_i (dep+b) reg q in
              a::l, b+d;
  in placement_i dep reg b

let analyse_placement_parametre dep reg para =
  match info_ast_to_info para with
  | InfoVar(_,t,_,_) -> modifier_adresse_variable (-dep - Type.getTaille t) reg para;
                        Type.getTaille t
  | _ -> failwith "Un paramètre est attendu"

let analyse_placement_fonction (AstType.Fonction(infoa, la, li)) = 
  let rec placement_parami dep reg lp = match lp with
    |[] -> ()
    |t::q -> let b = analyse_placement_parametre dep reg t in placement_parami (dep+b) reg q
              
  in placement_parami 0 "LB" (List.rev la);
  AstPlacement.Fonction(infoa, la, analyse_placement_bloc 3 "LB" li) 

let analyser (AstType.Programme (fonctions,prog)) =
  let nf = List.map (analyse_placement_fonction) fonctions in
  let nb = analyse_placement_bloc 0 "SB" prog in
  AstPlacement.Programme (nf,nb)