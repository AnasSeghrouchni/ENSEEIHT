
generic
   Capacite : integer;
    type T_Donnee1 is private;
    with Tableau;

package Tableau is

    type T_Arbre is limited private;
    package T_Tableau_Arbre is
		new TH (Capacite => 256, T_Cellule=>T_Arbre);
	use T_Tableau_Arbre;

-- Renvoie les indices des 2 arbres dont les fréquences sont les plus petites
    procedure Mins(Tab : in T_Tableau_Arbre ; Min1 : out integer ; Min2 : out integer ) with
    Post => Min1 > 0 and Min2>0 and Min1<Tab.Taille and Min2<Tab.Taille;


    Procedure Arbre(Tab : in T_Tableau ; Arbre : out T_Arbre) with
    ;

    --Savoir si un arbre n'a pas de fils gauche ni de fils droit (c'est une feuille).
    function Est_Feuille(Arbre : in) return boolean with;

    --Construire le code de l'arbre à partir de l'arbre
    function Code(Arbre:in T_Arbre) return


    -- Construit l'abrbre de Huffman lié au code de Huffmann présent au début du texte compressé
    function Construire_Arbre(Code: in T_LCA, Arbre : out T_Arbre);




private

   type T_Arbre;
   type T_Voisin is access T_Arbre;
   type T_Arbre is record
      Donnee1 : T_Donnee1;
      Frequence : integer;
      Droite : T_Voisin;
      Gauche : T_Voisin;
   end record;
end Tableau;
