with Arbre; use Arbre;
with ADA.IO_EXCEPTIONS;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Decompression is

    procedure Traitement(File_Name : in String; Tab: out T_Tab_Oct;String : out Unbounded_String) is

        File : Ada.Streams.Stream_IO.File_Type;
        Temporaire : T_Octet;
        S : Stream_Access;
        Compteur : integer:=1;
        Octet: T_Octet;
        Fin :Integer;

    begin

        Open(File,In_File,File_Name);
        S:=Stream(File);
        Fin:=Integer(T_Octet'Input(S));
        Tab.Tableau(Fin+1):=-1;
        while (Compteur<Fin+1) loop
            Octet:=T_Octet'Input(S);
            Temporaire:=Octet;
            Tab.Tableau(Compteur):=Octet;
            Compteur:=Compteur+1;
        end loop;
        Compteur:=Compteur+1;
        Octet:=T_Octet'Input(S);
        while Octet/=Temporaire loop
            Temporaire:=Octet;
            Tab.Tableau(Compteur):=Temporaire;
            Compteur:=Compteur+1;
            Octet:=T_Octet'Input(S);
        end loop;
        Tab.Taille:=Compteur-1;
        while not End_Of_File(File) loop
            Octet:=T_Octet'Input(S);
            for i in 0..7 loop
                String:=String & To_Unbounded_String((Slice(To_Unbounded_String(Integer'Image((Integer(Octet))/2**(7-i) mod 2)),2,2)));
            end loop;
        end loop;
        Close(File);
    end Traitement;


    procedure Decompresse(Nom_Fichier: in String) is
        File2: Ada.Streams.Stream_IO.File_Type;
        Arbre: T_Arbre;
        Table: T_Table;
        S2: Stream_Access;
        Fichier_String: Unbounded_String;
        Code:Unbounded_String;
        Compre:string(1..4);
        Ancien_nom:String(1..(Length(To_Unbounded_String(Nom_Fichier))-4));
        i_str:integer;
        B:Boolean;
        l:integer;
        Tableau:T_Tab_Oct;
        Temporaire:Unbounded_String;
        inutile1:T_Octet;
        inutile2:Unbounded_String;
    begin
        Fichier_String:=To_Unbounded_String(Nom_Fichier);
        l:=Length(Fichier_String);
        Compre:=Slice(Fichier_String,l-3,l);
        if Compre/=".hff" then
            raise ADA.IO_EXCEPTIONS.NAME_ERROR;
        end if;
        Traitement(Nom_Fichier,Tableau ,Code );
        Ancien_nom:=Slice(Fichier_String,1,l-4);
        i_str:=1;
        Reconstruction_Arbre(Arbre,Code,Tableau, i_str);
        Construction_Table(Arbre,Table);
        Fin_au_Debut(Table,inutile2,inutile1);
        Doubler_la_fin(Table);
        B:=True;
        Temporaire:= To_Unbounded_String("");
        Create(File2, Out_File, Ancien_nom);
        S2:=Stream(File2);
        While B loop
            if Temporaire=La_Donnee(Table,-1) then
                B:=False;
            elsif Donnee_Presente(Table, Temporaire) then
                T_Octet'Write(S2, La_Cle(Table,Temporaire));
                Temporaire:=To_Unbounded_String("");
            else
                Temporaire:=Temporaire & To_Unbounded_String(Slice(Code,i_str,i_str));
                i_str:=i_str+1;
            end if;
        end loop;
        Close(File2);
        put("######################Decompression realisée avec succès########################");
        New_Line;
        put("################################################################################");
        New_Line;
        New_Line;
        Put("Nom du fichier décompressé : ");
        Put(Ancien_nom);
        New_Line;
        New_Line;
        put("################################################################################");
        New_Line;
        put("##################################    FIN    ###################################");
    exception
        when ADA.IO_EXCEPTIONS.NAME_ERROR => Put("Le fichier que vous voulez décompresser n'existe pas ou n'est pas un fichier compressé.");
    end Decompresse;
end Decompression;
