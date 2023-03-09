with Arbre; use Arbre;
with ADA.IO_EXCEPTIONS;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Integer_Text_IO;use ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;

package body Compression is

    procedure Ecrit_Caracteres(S:in Stream_Access; Table : in T_Table) is
    begin
        if Est_Vide(Table) then
            Null;
        else
            T_Octet'Write(S, La_Cle(Table));
            Ecrit_Caracteres(S, Le_Prochain(Table));
        end if;
    end Ecrit_Caracteres;

    procedure Compresse(Nom_Fichier: in String; tiret_b : in Boolean) is
        File1, File2: Ada.Streams.Stream_IO.File_Type;
        S:T_Chaine;
        Arbre: T_Arbre;
        Table: T_Table;
        S1,S2: Stream_Access;
        Fichier_String: Unbounded_String:=To_Unbounded_String("");
        Octet,Position: T_Octet;
        Str : Unbounded_String;
        Code_Fin:Unbounded_String;
    begin
        Frequence(S,Nom_Fichier,File1);
        Construction_Arbre(S,Arbre);
        if tiret_b then
            New_Line;
            New_Line;
            New_Line;
            Put("################################Arbre de Huffman################################");
            New_Line;
            New_Line;
            New_Line;
            Afficher_Arbre(Arbre);
        end if;

        Initialiser(Table);
        Construction_Table(Arbre,Table);
        if tiret_b then
            New_Line;
            New_Line;
            New_Line;
            Put("###############################Table de Huffman#################################");
            New_Line;
            New_Line;
            New_Line;
            Fin_au_Debut(Table,Code_Fin,Position);
            Affiche_Table(Table);
            Doubler_la_fin(Table);
            New_Line;
            New_Line;
            New_Line;
            Code_Fin:=La_Donnee(Table,-1);
        else
            Fin_au_Debut(Table,Code_Fin,Position);
            Doubler_la_fin(Table);
        end if;

        Create(File2, Out_File, To_String(Nom_Fichier & To_Unbounded_String(".hff")));
        S2:=Stream(File2);

        T_Octet'Write(S2, Position);

        Ecrit_Caracteres(S2, Le_Prochain(Table));                -- 1) Caracteres en Octet selon parcours infixe

      Fichier_String:=Fichier_String & Code(Arbre);        -- 2) Code de l'arbre

      Open(File1, In_File, Nom_Fichier);
      S1:=Stream(File1);
      while not End_Of_File(File1) loop            -- 3) Fichier avec Octets transformés selon la table
         Fichier_String:=Fichier_String & La_Donnee(Table, T_Octet'Input(S1));
      end loop;
      Close(File1);

        Str:=Fichier_String & Code_Fin;
        for i in 1..(length(Str)/8) loop
            Octet:=0;
            for k in 1..8 loop
                if Element(Str,((i-1)*8+k))='0' then
                    Octet:=(Octet * 2) or 0;
                else
                    Octet:=(Octet*2) or 1;
                end if;
            end loop;
            T_Octet'Write(S2,Octet);
        end loop;
        Octet:=0;
        for i in ((length(Str)/8)*8+1)..length(Str) loop
            if Element(Str,i)='0' then
                Octet:=(Octet*2) or 0;
            else
                Octet:=(Octet*2) or 1;
            end if;
        end loop;

        if (length(Str) mod 8)/=0 then
            for i in 1..(8-(length(Str) mod 8)) loop
                Octet:=(Octet*2) or 0;
            end loop;
            T_Octet'Write(S2,Octet);
        end if;

        Close(File2);

        Vider_arbre(Arbre);
        Vider(Table);
        Vider_Sda(S);


        put("########################Compression realisée avec succès########################");
        New_Line;
        put("################################################################################");
        New_Line;
        New_Line;
        Put("Nom du fichier compressé : ");
        Put(Nom_Fichier);
        Put(".hff");
        New_Line;
        New_Line;
        put("################################################################################");
        New_Line;
        put("##################################    FIN    ###################################");
    exception
        when ADA.IO_EXCEPTIONS.NAME_ERROR => Put("Placez le fichier à compresser dans le bon dossier puis relancez ou verifiez l'orthographe du fichier à compresser.");

    end Compresse;
end Compression;
