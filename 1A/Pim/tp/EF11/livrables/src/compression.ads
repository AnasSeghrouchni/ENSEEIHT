package Compression is

   type T_Table is limited private;

   procedure Table(Arbre : in T_Arbre;Table : out T_Table);

   procedure Reecriture(Texte: in Ada.Streams.Stream_IO.File_Type;Nom_Texte: in string;
                        Texte_compressť: out Ada.Streams.Stream_IO.File_Type; Arbre : in T_Arbre);


private

   type T_Cell;

   type T_Chaine is access T_Cell;

   type T_Octet is mod 2**8;
   for T_Octet'Size use 8;

   type T_Bit is mod 2**1;
   for T_Bit'Size use 1;

   type T_Cell is record
      Bit:T_Bit;
      Suivant:T_Chaine;

   type T_Cellule is record
      Octet : T_Octet;
      Code : T_Chaine;

   type T_Table is array(1..Capacite) of T_Cellule;
