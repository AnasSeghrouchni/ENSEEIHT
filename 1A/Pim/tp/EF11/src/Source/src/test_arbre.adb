with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;


procedure test_arbre is
    Nom_Fichier : String :=  "text.txt";
    File      : Ada.Streams.Stream_IO.File_Type;
    S:T_Chaine;
    Arbre: T_Arbre;
    Chaine: T_Chaine;
    inutile:Unbounded_String;
begin
    Frequence(S,Nom_Fichier,File);
    New_Line;
    Construction_Arbre(S,Arbre);
    Put("L'arbre de Huffman est :");
    New_line;
    Afficher_Arbre(Arbre);
    new_Line;
    New_Line;
    put("Le code de l'arbre est :");
    New_Line;
    Put(To_String(Code(Arbre)));
    New_Line;
    Vider_Sda(S);
    Vider_arbre(Arbre);
end test_arbre;
