%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_CROOUV UL_CROFER
%token UL_PTVIRG UL_VIRG


/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT
%token <int> UL_ENTIER

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> array

/* Le non terminal document est l'axiome */
%start array

%% /* Regles de productions */

array : UL_CROOUV suite_array UL_FIN { (print_endline "array : UL_CROOUV suite_array UL_CROFER UL_FIN ") }

array_inter : UL_CROOUV suite_array { (print_endline "array_inter : UL_CROOUV suite_array ") }

suite_array : element_array UL_VIRG suite_array { (print_endline "suite_array : element_array UL_VIRG suite_array") }
            |element_array UL_PTVIRG suite_array{ (print_endline "suite_array : element_array UL_PTVIRG suite_array") }
            | element_array UL_CROFER { (print_endline "suite_array :  element_array UL_CROFER ") }

element_array :     array_inter { (print_endline "element_array : array ") }
                |UL_IDENT{ (print_endline "element_array : UL_IDENT ") }
                |UL_ENTIER{ (print_endline "element_array : UL_ENTIER ") }
%%
