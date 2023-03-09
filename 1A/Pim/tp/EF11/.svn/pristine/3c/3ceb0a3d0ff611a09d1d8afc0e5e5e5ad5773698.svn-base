with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;

package Decompression is

    --Prend le nom d'un fichier compressé et renvoie le tableau des caractère présent rangé dans l'odre du parcours infixe.
    --Renvoie aussi la suite du fichier (le code de l'arbre et les caractère compréssés).
    procedure Traitement(File_Name : in String; Tab : out T_Tab_Oct;String : out Unbounded_String);

    --Decompresse un fichier compressé.
    procedure Decompresse(Nom_Fichier : in String);


end Decompression;
