with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table; use Table;


package Arbre is

    type T_Tableau is array(1..260) of T_Octet;

    type T_Tab_Oct is record
        Tableau:T_Tableau;
        Taille:integer;
    end record;

    type T_Arbre is private;

    type T_Chaine is private;

    --Savoir si un arbre n'a pas de fils gauche ni de fils droit (est une feuille).
    function Est_Feuille(Arbre : in T_Arbre) return boolean ;

    --Savoir si un Arbre est Vide.
    function Est_Vide_Arbre(Arbre : in T_Arbre) return Boolean;

    --Construire le code de l'arbre à  partir de l'arbre.
    function Code(Arbre:in T_Arbre) return Unbounded_String;

    -- Vider un arbre pour éviter les fuites de mémoire.
    procedure Vider_arbre (Arbre: in out T_Arbre);

    --Parcours un fichier et rempli un structure chainée composée de noeud.
    procedure Frequence(Sda : in out T_Chaine; File_Name : in String ;File : in out Ada.Streams.Stream_IO.File_Type);

    -- Initialiser une chaine. La chaine est vide.
    procedure Initialiser(Sda: out T_Chaine) ;

    -- Est-ce qu'une Sda est vide ?
    function Est_Vide (Sda : T_Chaine) return Boolean;

   --Ajouter un noeud associé à un caractere dans la chaine s'il n'y est pas, incrémenter sa frequence correspondante s'il y est.
    procedure Enregistrer (Sda : in out T_Chaine ; Octet : in T_Octet) ;

    --Crée un Noeud avec comme clé Octet et 2 fils Null.
    procedure Enregistrer_Feuille(Arbre:out T_Arbre; Octet : in T_Octet);

    --Construit l'arbre de Huffman.
    procedure Construction_Arbre(Sda: in out T_Chaine; Arbre : out T_Arbre);

    --Construit la table de Huffman à partir d'un arbre.
    procedure Construction_Table(Arbre : in T_Arbre; Table : out T_Table);

    -- Supprimer tous les éléments d'une Sda.
    procedure Vider_Sda (Sda : in out T_Chaine);

    --Supprimer la PREMIERE case contenant la frequence Frequence.
    procedure Supprimer( Sda : in out T_Chaine;Frequence : in integer) ;

    --Permet d'afficher un Arbre.
    procedure Afficher_Arbre(Arbre:in T_Arbre);

    --Renvoie la fils Gauche d'un arbre.
    function Gauche(Arbre : in out T_Arbre) return T_Arbre;

    --Renvoie le fils Droit d'un arbre.
    function Droite(Arbre : in out T_Arbre) return T_Arbre;

    --Reconstruit l'arbre.
    --Octet : Tableau contenant les caractère present dans le fichier dans l'odre infixe de l'arbre.
    --Code : Suite du fichier compressé (après l'énumération des caractère) transformé en Unbounded String.
    --i_str indice parcourant notre code.
    procedure Reconstruction_Arbre(Arbre:out T_Arbre; Code : in Unbounded_String; Octet:in T_Tab_Oct;i_str:in out integer);

private

    type T_Noeud;
    type T_Arbre is access T_Noeud;
    type T_Noeud is record
        Cle : T_Octet;
        Donnee : integer;
        Droite : T_Arbre;
        Gauche : T_Arbre;
    end record;

    type T_Cellule;
    type T_Chaine is access T_Cellule;
    type T_Cellule is record
        Arbre : T_Arbre;
        Suivante : T_Chaine;
    end record;

end Arbre;
