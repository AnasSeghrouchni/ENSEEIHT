with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;
with DeCompression; use Decompression;

procedure test_decompression is
   Nom_Fichier: String:="text.txt.hff";
    Tableau:T_Tab_Oct;
    String:Unbounded_String;
    i_str:integer:=1;
    Arbre:T_Arbre;
begin
    New_Line;
    New_Line;
    Traitement(Nom_Fichier,Tableau,String);
    Put("Le fichier compressé sans les caractères de début :");
            New_Line;
    Put(To_String(String));
    New_Line;
    Put("L'arbre reconstruit est : ");
    New_line;
            New_Line;
    Reconstruction_Arbre(Arbre,String,Tableau ,i_str);
    Afficher_Arbre(Arbre);
    New_line;
    Vider_arbre(Arbre);
    Decompresse(Nom_Fichier);

end;
