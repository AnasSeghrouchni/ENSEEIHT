with Arbre; use Arbre;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table; use Table;

procedure test_table is
    Nom_Fichier : String :=  "text.txt";
    File      : Ada.Streams.Stream_IO.File_Type;
    S:T_Chaine;
    Arbre: T_Arbre;
    Chaine: T_Chaine;
    inutile:Unbounded_String;
    Table:T_Table;
    code:Unbounded_String;
    octet:T_Octet;
begin
    Frequence(S,Nom_Fichier,File);
    Construction_Arbre(S,Arbre);
    Construction_Table(Arbre,Table);
    Put("La table de départ est :");
    New_Line;
    Affiche_Table(Table);
    New_Line;
    Put("Table avec la fin au debut :" );
    New_Line;
    Fin_au_Debut(Table,code,octet);
    New_Line;
    Affiche_Table(Table);
    New_Line;
    Put("Table en doublant la fin :");
    New_Line;
    Doubler_la_fin(Table);
    Affiche_Table(Table);
    Vider_arbre(arbre);
    Vider(Table);
end test_table;
