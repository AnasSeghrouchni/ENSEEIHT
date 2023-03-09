with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;

package Compression is

   --Ecrit les caractères d'une table au début du fichier compressé.
   procedure Ecrit_Caracteres(S:in Stream_Access; Table : in T_Table);

   --Compresse un fichier avec ou sans bavard.
   procedure Compresse(Nom_Fichier: in String; tiret_b :in Boolean);

end Compression;
