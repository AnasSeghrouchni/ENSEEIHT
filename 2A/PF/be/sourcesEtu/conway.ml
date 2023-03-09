(* Exercice 1*)

(* max : int list -> int  *)
(* Paramètre : liste dont on cherche le maximum *)
(* Précondition : la liste n'est pas vide *)
(* Résultat :  l'élément le plus grand de la liste *)
let max l = 
  let rec aux l max =
    match l with
    |[] -> max
    |t::q -> if t>max then aux q t else aux q max
  in aux l (List.hd l)

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
let%test _ = max [ 1 ] = 1
let%test _ = max [ 1; 2 ] = 2
let%test _ = max [ 2; 1 ] = 2
let%test _ = max [ 1; 2; 3; 4; 3; 2; 1 ] = 4


(* max_max : int list list -> int  *)
(* Paramètre : la liste de listes dont on cherche le maximum *)
(* Précondition : il y a au moins un élement dans une des listes *)
(* Résultat :  l'élément le plus grand de la liste *)
let max_max list_list = max (List.map(max) list_list)

(* TO DO : copier / coller les tests depuis conwayTests.txt *)
let%test _ = max_max [ [ 1 ] ] = 1
let%test _ = max_max [ [ 1 ]; [ 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 2 ]; [ 1; 1; 2; 1; 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 1 ] ] = 2
let%test _ = max_max [ [ 1; 1; 2; 1 ]; [ 1; 2; 2 ] ] = 2
let%test _ =
  max_max [ [ 1; 1; 1 ]; [ 2; 1; 2 ]; [ 3; 2; 1; 4; 2 ]; [ 1; 3; 2 ] ] = 4

(* Exercice 2*)

(* compteur : 'a -> 'a list -> int -> int*'a list *)
(* Calcule le nombre de terme égaux consécutifs aux debut d'une liste et renvoie la liste restante en enlevant les termes égaux*)
(* Paramètre x : le terme dont les temes de début de liste sont égaux *)
(* Paramètre liste : la liste *)
(* Paramètre cb_x : le nombres de termes égaux *)
(* Retour : un couple contenant le nombre de terme égaux et le reste de la liste *)
let rec compteur x liste cb_x = match liste with
|[] -> (cb_x,[])
|t::q -> if t = x then (compteur x q (cb_x+1)) else (cb_x,t::q)

(* suivant : int list -> int list *)
(* Calcule le terme suivant dans une suite de Conway *)
(* Paramètre : le terme dont on cherche le suivant *)
(* Précondition : paramètre différent de la liste vide *)
(* Retour : le terme suivant *)

let rec suivant l = 
  match l with
  |[] -> []
  |t::q -> if q = [] then 1::t::[] else
          if t <> (List.hd q) then 1::t::(suivant q) else 
          let (nb_t,reste) = (compteur t q 1) in nb_t::t::(suivant reste)
          


(* TO DO : copier / coller les tests depuis conwayTests.txt *)
let%test _ = suivant [ 1 ] = [ 1; 1 ]
let%test _ = suivant [ 2 ] = [ 1; 2 ]
let%test _ = suivant [ 3 ] = [ 1; 3 ]
let%test _ = suivant [ 1; 1 ] = [ 2; 1 ]
let%test _ = suivant [ 1; 2 ] = [ 1; 1; 1; 2 ]
let%test _ = suivant [ 1; 1; 1; 1; 3; 3; 4 ] = [ 4; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 1; 1; 3; 3; 4 ] = [ 3; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 3; 3; 4 ] = [ 1; 1; 2; 3; 1; 4 ]
let%test _ = suivant [3;3] = [2;3]

(* suite : int -> int list -> int list list *)
(* Calcule la suite de Conway *)
(* Paramètre taille : le nombre de termes de la suite que l'on veut calculer *)
(* Paramètre depart : le terme de départ de la suite de Conway *)
(* Résultat : la suite de Conway *)
let rec suite taille depart = 
  if taille = 1 then [depart] else let suiv = suivant depart in
  depart::(suite (taille-1) suiv)
  
(* TO DO : copier / coller les tests depuis conwayTests.txt *)
let%test _ = suite 1 [ 1 ] = [ [ 1 ] ]
let%test _ = suite 2 [ 1 ] = [ [ 1 ]; [ 1; 1 ] ]
let%test _ = suite 3 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ] ]
let%test _ = suite 4 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1 ] ]


(* Tests de la conjecture *)
(* "Aucun terme de la suite, démarant à 1, ne comporte un chiffre supérieur à 3" *)
(* TO DO *)
let%test _ = (max_max (suite 10 [ 1 ])) <= 3
let%test _ = (max_max (suite 25 [ 1 ])) <= 3
let%test _ = (max_max (suite 30 [ 1 ])) <= 3
(* Remarque : Ce test est très couteux, la fonction max_max va parcourir chaque terme d'une suite de termes de Conway dont la taille(a vu d'oeil) ouble presque à chaque terme donc le parcours est en O(2**n) avec n le nombre de terme de conway que l'on veut calculer, ainsi on ne peut pas savoir pour des grandes valeurs de n si on va depasser 3 *)