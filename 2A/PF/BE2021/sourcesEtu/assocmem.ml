open Util
open Mem

(* get_assoc: 'a -> ('a * 'b) list -> 'b -> 'b
    Retourne la valeur associée à une clef dans une liste et renvoie une valeur par default si la clef n'est pas trouvée
* Paramètres :
*   e : 'a, la clef
*   l : ('a * 'b) list, la liste de clef, valeur
*   def : 'b , valeur par default
* Retour :
*   la valeur associée à la clef
 *)
let rec get_assoc e l def = match l with
    |[] -> def
    |(cle,valeu)::q -> if cle=e then valeu else (get_assoc e q def)

(* Tests unitaires : *)
let%test _= get_assoc 3 [(1,3);(4,48); (78,69); (3,24)] (-1) = 24
let%test _= get_assoc 'a' [('a',3);('b',48); ('c',69); ('d',24)] (-1) = 3
let%test _= get_assoc 42 [(1,3);(4,48); (78,69)] (-1) = -1
let%test _= get_assoc 14 [(14,'a');(45,'b')] ('y') = 'a'

(* set_assoc : TODO
 *)
let rec set_assoc e l x = match l with
|[] -> [(e,x)]
|(cle,valeur)::q -> if cle=e then (cle,x)::q else
                    (cle,valeur)::(set_assoc e q x)

(* Tests unitaires : TODO *)
let%test _= set_assoc 3 [(1,3);(4,48); (78,69); (3,24)] (-1) = [(1,3);(4,48); (78,69); (3,-1)]
let%test _= set_assoc 'a' [('a',3);('b',48); ('c',69); ('d',24)] (1515) = [('a',1515);('b',48); ('c',69); ('d',24)]
let%test _= set_assoc 42 [(1,3);(4,48); (78,69)] (-1) = [(1,3);(4,48); (78,69);(42,-1)]
let%test _= set_assoc 45 [(14,'a');(45,'b')] ('y') = [(14,'a');(45,'y')]

module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = (int*char) list

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (_, m) = 2 * (List.length m )

    (* Nombre de cases utilisées *)
    let busyness (_, m) = List.fold_right (fun (c,v) compteur -> if v = _0 then compteur else (compteur+1)) m 0

    (* Construire une mémoire vide *)
    let clear bs = (bs,[])

    (* Lire une valeur *)
    let read (bs, m) addr = if addr >= size (bs, m) then 
                        raise OutOfBound 
                        else
                        get_assoc addr m (_0)

    (* Écrire une valeur *)
    let write (bs, m) addr x = if addr >= size (bs,m) then 
        raise OutOfBound 
        else
        (bs, set_assoc addr m x)
end
