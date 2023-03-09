--Définition d'une structure chainée codant une table du Huffman

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Table is

    type T_Octet is mod 2**8;

    type T_Table is limited private;

    --Initialise une Table de Huffmann. La Table est vide.
    procedure Initialiser(Table: out T_Table) ;

	-- Est-ce qu'une Table est vide ?
    function Est_Vide (Table : T_Table) return Boolean;

    --Renvoie la taille d'une Table de Huffman.
    function Taille (Table : in T_Table) return Integer;

    --Renvoie la position d'une Cle dans la table de Hufman.
    function La_Position (Table : in T_Table ; Cle : in T_Octet) return integer;

    --Renvoie la donnée (le code) associée à une clé.
    function La_Donnee(Table : in T_Table ; Cle : in T_Octet) return Unbounded_String;

    --Renvoie la clé (l'octet) associée à une donnée (un code).
    function La_Cle(Table : in T_Table ; Donnee : in Unbounded_String) return T_Octet;

    --Renvoie la clé du premier enregistrement de la table..
    function La_Cle(Table: in T_Table) return T_Octet;

    --Savoir si une clé est présente dans une Table.
    function Cle_Presente (Table : in T_Table ; Cle : in T_Octet) return Boolean;

    --Savoir si une donnée est présente dans une Table.
    function Donnee_Presente (Table : in T_Table ; Donnee : in Unbounded_String) return Boolean;

    --Renvoie la suite de la table.
    function Le_Prochain(Table:in T_Table) return T_Table;

    --Enregistre un couple (Clé,Donnée) d'une Table de Hufmann.
    procedure Enregistrer (Table : in out T_Table ; Cle : in T_Octet ; Donnee : in Unbounded_String);

    --Supprime le couple (Clé,Donnée) dans une Table de Hufmann.
    procedure Supprimer(Table : in out T_Table; Cle : in T_Octet);

    --Permet de modifier une table afin de mettre le caractère de fin de fichier au
    --début de la table et de renvoyer sa position en octet afin de ne pas la perdre et son code.
     procedure Fin_au_Debut(Table: in out T_Table; Code: out Unbounded_String; Octet : out T_Octet);

    --Modifie une table afin de doubler le dernier caratère.
    procedure Doubler_la_fin(Table: in out T_Table);

    --Permet de vider une table afin d'éviter les fuites de mémoire.
    procedure Vider (Table : in out T_Table) ;

    --Affiche un caratère lié à un octet.
    procedure Affiche_Caractere(Octet: in T_Octet);

    --Affiche une Table de Huffman.
    procedure Affiche_Table(Table: in T_Table);

private

    type T_Cellule;

    type T_Table is access T_Cellule;

    type T_Cellule is record
        Cle : T_Octet;
        Donnee : Unbounded_String;
        Prochain : T_Table;
    end record;

end Table;
