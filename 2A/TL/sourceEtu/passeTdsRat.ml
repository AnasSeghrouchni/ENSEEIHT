(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme


let rec analyse_tds_affectable tds a =
  match a with
  | AstSyntax.Ident s ->
              (match chercherGlobalement tds s with
              | None -> raise (IdentifiantNonDeclare s)
              | Some infoa -> (match info_ast_to_info infoa with
                            | InfoVar _ ->  AstTds.Ident infoa
                            | InfoConst _ -> AstTds.Ident infoa
                            | _ -> raise (MauvaiseUtilisationIdentifiant s)))
 | AstSyntax.Dereference a -> let na = analyse_tds_affectable tds a in
                        AstTds.Dereference na
          




(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_expression tds e = match e with
  | AstSyntax.Booleen b -> AstTds.Booleen b
  | AstSyntax.Entier i -> AstTds.Entier i
  | AstSyntax.Unaire (u,e1) ->  AstTds.Unaire (u,analyse_tds_expression tds e1)
  | AstSyntax.Binaire (b,e1,e2) -> AstTds.Binaire (b,analyse_tds_expression tds e1,analyse_tds_expression tds e2)
  | AstSyntax.AppelFonction (s, l) ->
      (match chercherGlobalement tds s with
      | None -> raise (IdentifiantNonDeclare s)
      | Some a -> (match info_ast_to_info a with
                  | InfoFun _ -> AstTds.AppelFonction (a, (List.map(analyse_tds_expression tds) l))
                  | _ -> raise (MauvaiseUtilisationIdentifiant s)))
  | AstSyntax.Affectable a -> AstTds.Affectable(analyse_tds_affectable tds a)
  | AstSyntax.Ternaire (e1, e2, e3) ->
    let ne1 = analyse_tds_expression tds e1 in
    let ne2 = analyse_tds_expression tds e2 in
    let ne3 = analyse_tds_expression tds e3 in
    AstTds.Ternaire(ne1, ne2, ne3)
  | AstSyntax.New n -> AstTds.New n
  | AstSyntax.Null -> AstTds.Null
  | AstSyntax.Adresse s -> 
    begin
      match chercherGlobalement tds s with
      |None -> raise (IdentifiantNonDeclare s)
      |Some ia -> 
        begin
          match info_ast_to_info ia with
          |InfoVar _ -> AstTds.Adresse ia
          | _ -> raise (MauvaiseUtilisationIdentifiant s)
        end
      end

(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (a,e) ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
       let ne = analyse_tds_expression tds e in
      (* Vérification de la bonne utilisation des identifiants dans l'affectable *)
      (* et obtention de l'affectable transformé *)
      let na = analyse_tds_affectable tds a in
      begin 
        match na with 
        |AstTds.Ident ia ->
            begin 
              match info_ast_to_info ia with 
              | InfoVar _ ->   (* Renvoie de la nouvelle affectation où l'affectable a été remplacé par l'affectable issue de l'analyse
                                et l'expression remplacée par l'expression issue de l'analyse *)
                                AstTds.Affectation (na, ne)
            | InfoConst(s,_) -> raise (MauvaiseUtilisationIdentifiant s)
            end
        |AstTds.Dereference _ -> AstTds.Affectation (na, ne)
          end
  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds oia t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds oia li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli

(* ajouter_double_decla : tds -> (typ*string) -> (typ * info_ast) *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre (t,n) : le type et le nom de la variable à ajouter *)
(* Ajoute la variable dans la tds et transforme en  (typ * info_ast) *)
(* Erreur si la variable est déjà déclarée *)
let ajouter_double_decla tds (t,n) = 
  match chercherLocalement tds n with 
  | Some _ -> raise (DoubleDeclaration n)
  | None -> 
    let infoa = info_to_info_ast (InfoVar(n, t, 0, "")) in ajouter tds n infoa;
    (t, infoa)


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li))  = 
      match chercherGlobalement maintds n with
      | Some infoa -> 
        begin
          match info_ast_to_info infoa with 
          |InfoFun(n, t, ltp) -> if ltp = (fst (List.split lp)) then 
                          raise (DoubleDeclaration n) 
                          else 
                          let tdsfille = creerTDSFille maintds in
                          ajouter maintds n infoa;
                          ajouter tdsfille n infoa;
                          let nlp = List.map (ajouter_double_decla tdsfille) lp in
                          let nli = List.map (analyse_tds_instruction  tdsfille (Some infoa)) li in
                        AstTds.Fonction (t, infoa, nlp, nli)
          |_ -> failwith "Impossible une fonction doit être décalaré"
          end
      | None -> 
        let tdsfille = creerTDSFille maintds in
        let infoa = info_to_info_ast (InfoFun(n, t, fst (List.split lp)))  in
        ajouter maintds n infoa;
        ajouter tdsfille n infoa;
        let nlp = List.map (ajouter_double_decla tdsfille) lp in
        let nli = List.map (analyse_tds_instruction  tdsfille (Some infoa)) li in
        AstTds.Fonction (t, infoa, nlp, nli)




(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds) fonctions in
  let nb = analyse_tds_bloc tds None prog in
  AstTds.Programme (nf,nb)