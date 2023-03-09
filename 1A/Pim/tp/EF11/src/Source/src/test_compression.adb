with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;
with Compression; use Compression;

procedure test_compression is
   Nom_Fichier: String:="text.txt";
begin
    Compresse(Nom_Fichier,True);
end;
