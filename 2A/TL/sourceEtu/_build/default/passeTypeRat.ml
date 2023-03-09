(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

let rec analyse_type_affectable a =
  match a with 
  |AstTds.Ident info -> 
    begin
    match info_ast_to_info info with
    | InfoConst(_,_) -> (AstType.Ident info), Int
    | InfoVar(_,t,_,_) -> (AstType.Ident info), t
    | InfoFun(_,t,_) -> (AstType.Ident info), t
    end 
  | AstTds.Dereference a -> let (na,ta) = analyse_type_affectable a in
                            match ta with
                            |Pointeur t -> (AstType.Dereference na), t;
                            | _ -> raise (TypeInattendu(ta,Pointeur Undefined))

(* analyse_tds_expression : AstTds.expression -> AstType.expression -> Type.typ*)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_expression e = match e with
  | AstTds.Booleen b -> AstType.Booleen b , Bool
  | AstTds.Entier i -> AstType.Entier i , Int
  | AstTds.Unaire (Numerateur,e1) ->  (let (e,t) = analyse_type_expression e1 in
                                       if (est_compatible t Rat) then (AstType.Unaire(Numerateur,e),Int) else
                                       raise (TypeInattendu(t,Rat)))
  | AstTds.Unaire (Denominateur,e1) ->  (let (e,t) = analyse_type_expression e1 in
                                       if (est_compatible t Rat) then (AstType.Unaire(Denominateur,e),Int) else
                                       raise (TypeInattendu(t,Rat)))
  | AstTds.Binaire (b,e1,e2) -> let (e11,t1) = analyse_type_expression e1 in 
                                let (e22,t2) = analyse_type_expression e2 in
                                if (est_compatible t1 t2) then (
                                match b with
                                |Inf when t1 = Int -> AstType.Binaire(Inf,e11,e22), Bool
                                |Mult when t1 = Int -> AstType.Binaire(MultInt,e11,e22),Int
                                |Mult when t1 = Rat -> AstType.Binaire(MultRat,e11,e22),Rat
                                |Plus when t1 = Int -> AstType.Binaire(PlusInt,e11,e22),Int
                                |Plus when t1 = Rat -> AstType.Binaire(PlusRat,e11,e22),Rat
                                |Equ when t1 = Bool -> AstType.Binaire(EquBool,e11,e22),Bool
                                |Equ when t1 = Int -> AstType.Binaire(EquInt,e11,e22),Bool
                                |Fraction when t1 = Int -> AstType.Binaire(Fraction,e11,e22),Rat
                                |_ -> raise (TypeBinaireInattendu(b,t1,t2))
                                )
                                else raise (TypeBinaireInattendu(b,t1,t2))
  | AstTds.Affectable a -> let (a1,t) = analyse_type_affectable a in
                            (AstType.Affectable a1), t
  | AstTds.AppelFonction(infoa,le) -> 
                          let (lne, lte) = List.split (List.map analyse_type_expression le) in 
                          begin
                              match info_ast_to_info infoa with 
                                  |InfoFun (_, t, ltp) ->
                                    if est_compatible_list lte ltp then
                                      (AstType.AppelFonction (infoa, lne), t)
                                    else
                                      raise (TypesParametresInattendus (ltp, lte))
                                  | _ -> failwith "une fonction est attendue"
                                    end
 | AstTds.Null -> AstType.Null, Pointeur Undefined
 | AstTds.Ternaire(e1, e2, e3) -> let (ne1,te1) = analyse_type_expression e1 in
                                  let (ne2,te2) = analyse_type_expression e2 in
                                  let (ne3,te3) = analyse_type_expression e3 in
              if (est_compatible te1 Bool) then 
                if (est_compatible te2 te3) then 
                  (AstType.Ternaire(ne1,ne2,ne3),te2)
                  else raise (TypeInattendu(te3,te2))
                else raise (TypeInattendu(te1,Bool))
| AstTds.New t -> AstType.New t, Pointeur t
| AstTds.Adresse a ->
  begin
    match info_ast_to_info a with
                      |InfoVar(_,t,_,_) -> AstType.Adresse a, Pointeur t
                      |_ -> failwith "Une variable attendue"
  end






(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des type et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration(t,infoa,e) ->
      let (e1,t1) = analyse_type_expression e in
      if est_compatible t t1 then 
        begin
        modifier_type_variable t infoa; AstType.Declaration(infoa,e1)
        end
      else raise (TypeInattendu(t1,t))

  | AstTds.Affectation (a,e) ->
      let (a1,t1) = analyse_type_affectable a in
      let (e1,t2) = analyse_type_expression e in
      if est_compatible t1 t2 then
        AstType.Affectation(a1,e1)
      else raise (TypeInattendu(t2,t1))

    (*      let InfoVar(a,t,b,c) = info_ast_to_info infoa in 
      let (e,t1) = analyse_type_expression e in
      if est_compatible t t1 then
        AstType.Affectation(infoa,e)
      else raise (TypeInattendu(t1,t))
      *)
  | AstTds.Affichage ne -> (let (e,t) = analyse_type_expression ne in
                          match t with
                          | Int ->  AstType.AffichageInt (e)
                          | Rat ->  AstType.AffichageRat (e)
                          | Bool -> AstType.AffichageBool (e)
                          | _ -> failwith "Impossible"
                        )
  | AstTds.Conditionnelle (b,x1,x2) ->(
      let (e,t) = analyse_type_expression b in
      let bloc = analyse_type_bloc x1 in
      let bloc2 = analyse_type_bloc x2 in
      if est_compatible t Bool then
        AstType.Conditionnelle(e,bloc,bloc2)
      else raise (TypeInattendu(t,Bool))
      )
  | AstTds.TantQue (nc,bast) ->(
      (* Analyse de la condition *)
      let (e,t) = analyse_type_expression nc in
      (* Analyse du bloc *)
      let bloc = analyse_type_bloc bast in
      if est_compatible t Bool then
        AstType.TantQue(e,bloc) 
      else raise (TypeInattendu(t,Bool))
  )
  | AstTds.Retour (e,infoa) ->
    begin
      match info_ast_to_info infoa with
      | InfoFun(_,t,_) ->let (e1,t1) = analyse_type_expression e in
                            if est_compatible t t1 then
                              AstType.Retour(e1,infoa)
                            else raise (TypeInattendu(t1,t))
      |_ -> failwith "Une fonction est attendue"
    end
  | AstTds.Empty -> AstType.Empty        

(* analyse_tds_bloc :  AstTds.bloc -> AstType.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_bloc li =
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map(analyse_type_instruction) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli

let analyse_type_fonction (AstTds.Fonction(t, info, lp, li))  =
    let (type_lp, info_lp) = List.split lp in
    let nli = analyse_type_bloc li in 
    begin
      modifier_type_fonction t type_lp info;
    AstType.Fonction(info, info_lp, nli)
    end

let analyser (AstTds.Programme (fonctions,prog)) =
  let nf = List.map (analyse_type_fonction) fonctions in
  let nb = analyse_type_bloc prog in
  AstType.Programme (nf,nb)