--Definition d'une structure chainée simple (Une Clé et un pointeur)
with Ada.Unchecked_Deallocation;
with Ada.Text_IO;  use Ada.Text_IO;

generic
    type T_Cle is private;

package Suite is

    type T_Suite is private;

    --Permet de vider un sda.
    procedure Vider (Sda : in out T_Suite);

    --Initialise une sda.
    Procedure Initialiser(Sda: out T_Suite) ;

    --Savoir si sda est vide.
    function Est_Vide(Sda : in T_Suite) return Boolean ;

    --Enregistre une nouvelle clé.
    procedure Enregistrer(Sda : in out T_Suite; Cle : in T_Cle) ;

    --Savoir si une clé est présente.
    function Est_Present(Sda : in T_Suite;Cle: in T_Cle) return Boolean;

    --Supprime une clé de la sda.
    procedure Supprimer(Sda : in out T_Suite; Cle : in T_Cle) ;

private

    type T_Cellule;
    type T_Suite is access T_Cellule;
    type T_Cellule is record
        Cle:T_Cle;
        Suivante:T_Suite;
    end record;

end Suite;
