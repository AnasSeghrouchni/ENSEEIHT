with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;


generic
   Capacite:integer;
   type T_Cellule is private;

package Tableau is

   type T_Tableau is limited private;
   type T_Octet is private;

   --initialise un tableau vide
   procedure Initialiser(Tab: out T_Tableau) with
     Post => Est_Vide(Tab);

   --Tab est-il vide ?
   procedure Est_Vide(Tab: in T_Tableau) with
     Post => Tab.Taille=0;

   --Taille de Tab
   function Taille(Tab:in T_Tableau) return integer with
     Post=> Taille'Result>= 0 and (Taille'Result=0) = Est_Vide(Tab);

   --Ajouter un caractere dans le tableau s'il n'y est pas, incrÃ©menter sa frÃ©quence correspondante s'il y est
   procedure Enregistrer(Tab: in out T_Tableau;Octet : in T_Octet) with
     Post => Caractere_present(Tab) and Frequence_Caractere(Tab,Octet)=Frequence_Caractere(Tab,Octet)'Old +1
     and (not (Caractere-present(Tab,Caractere)'Old) or Taille(Tab)=Taille(Tab)'Old);

<<<<<<< .mine
   --Lire un texte et remplir un tableau faisant correspondre les caractères du texte et leurs fréquence d'apparition
   procedure Remplir(Tab: in out T_Tableau; File: in Ada.Streams.Stream_IO.File_Type;File_Name: in string) with
||||||| .r244570
   --Lire un texte et remplir un tableau faisant correspondre les caractères du texte et leurs fréquence d'apparition
   procedure Remplir(Tab: in out T_Tableau; File: in Ada.Streams.Stream_IO.File_Type) with
=======
   --Lire un texte et remplir un tableau faisant correspondre les caractÃ¨res du texte et leurs frÃ©quence d'apparition
   procedure Remplir(Tab: in out T_Tableau; File: in Ada.Streams.Stream_IO.File_Type; File_Name: in String) with
>>>>>>> .r244579
     Post => Tab.Taille>=Tab.Taille'Old;

   --Vide un tableau
   procedure Vider(Tab: in out T_Tableau) with
     Post => Tab.Taille=0;

   --Savoir si un caractere est present dans Tab
   function CaractÃ¨re_present(Tab : in T_Tableau; Caractere : T_Octet) return boolean;

   --Connaitre la frequence associÃ©e Ã  un caractere
   function Frequence_Caractere(Tab : in T_Tableau; Caractere : T_Octet) return integer;


private

   type T_Tab is array(1..Capacite) of T_Cellule;

   type T_Octet is mod 2 ** 8;	-- sur 8 bits
   for T_Octet'Size use 8;

   type T_Tableau is record
      Tableau : T_Tab;
      Taille: integer;
   end record;

end Tableau;
