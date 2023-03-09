with Ada.Unchecked_Deallocation;
with Piles;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO; use  Ada.Text_IO.Unbounded_IO;
with Ada.Text_IO;           use Ada.Text_IO;
with Table; use Table;
with Suite;

package body Arbre is

    procedure Free_Arbre is
            new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_Arbre);

    function Est_Feuille (Arbre: in T_Arbre) return Boolean is
    begin
        return Arbre.Droite=Null and Arbre.Gauche=Null;
    end Est_Feuille;


    function Est_Vide_Arbre ( Arbre : in T_Arbre) return Boolean is
    begin
        return Arbre=Null;
    end Est_Vide_Arbre;


    package Piles_Arbre is
            new Piles(T_Element=>T_Arbre);
    use Piles_Arbre;


    function Code(Arbre:in T_Arbre) return Unbounded_String is
        Temporaire : T_Arbre;
        Code_Arbre:Unbounded_String;
        P:T_Pile;
    begin
        Code_Arbre:=To_Unbounded_String("");
        Initialiser(P);
        Empiler(P,Arbre);
        while not Est_Vide(P) loop
            Temporaire:=Sommet(P);
            Depiler(P);
            if Est_Feuille(Temporaire)  then
                Code_Arbre:=Code_Arbre & To_Unbounded_String("1");
            else
                Empiler(P,Temporaire.all.Droite);
                Empiler(P,Temporaire.all.Gauche);
                Code_Arbre:=Code_Arbre & To_Unbounded_String("0");

            end if;
        end loop;
        Detruire(P);
        return Code_Arbre;
    end Code;


    procedure Vider_arbre(Arbre : in out T_Arbre) is
    begin
        if Arbre=Null then
            Null;
        else
            Vider_arbre(Arbre.Gauche);
            Vider_arbre(Arbre.Droite);
            Free_Arbre(Arbre);
        end if;
    end Vider_arbre;

    procedure Free_Sda is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Chaine);


    --Initialise une Sda nous servant à creer l'arbre.
    Procedure Initialiser(Sda: out T_Chaine) is
    begin
        Sda:=Null;
    end;

    --Savoir si une Sda est vide.
    function Est_Vide(Sda : in T_Chaine) return Boolean is
    begin
        return Sda=Null;
    end;

    --Enregistre soit un nouveau noeud de fréquence 1 ou increment la frequence de l'octet déjà présent.
    procedure Enregistrer(Sda : in out T_Chaine; Octet : in T_Octet) is
    begin
        if Sda=Null then
            Sda:= New T_Cellule;
            Sda.all.Arbre:=new T_Noeud;
            Sda.all.Arbre.all.Donnee:=1;
            Sda.all.Arbre.all.Cle:=Octet;
            Sda.all.Arbre.all.Gauche:=Null;
            sda.all.Arbre.all.Droite:=Null;
            Sda.all.Suivante:=Null;
        elsif Sda.all.Arbre.all.Cle = Octet then
            Sda.all.Arbre.all.Donnee:=Sda.all.Arbre.all.Donnee+1;
        else
            Enregistrer(Sda.all.Suivante,Octet);
        end if;

    end enregistrer;

    --Creer un clé de fréquence nulle (utile pour la reconstruction de l'arbre).
    procedure Enregistrer_Feuille(Arbre:out T_Arbre; Octet : in T_Octet) is
    begin
        Arbre:=New T_Noeud;
        Arbre.all.Cle:=Octet;
        Arbre.all.Donnee:=0;
        Free_Arbre(Arbre.all.Droite);
        Free_Arbre(Arbre.all.Gauche);
    end Enregistrer_Feuille;

    --Permet de vider une sda.
    procedure Vider_Sda(Sda : in out T_Chaine) is
    begin
        if Sda=Null then
            null;
        else
            Vider_Sda(Sda.all.Suivante);
            Free_Sda(Sda);
        end if;
    end Vider_Sda;

    --Parcours le fichier à compressé et enregistre chaque octet rencontré dans la sda de noeud.
    procedure Frequence(Sda : in out T_Chaine; File_Name : in String ;File : in out Ada.Streams.Stream_IO.File_Type) is
        S : Stream_Access;
        Octet : T_Octet;
        Ch:T_Chaine;
    begin
        Initialiser(Sda);
        Open(File,In_File,File_Name);
        S:=Stream(File);
        while not End_Of_File(File) loop
            Octet:=T_Octet'Input(S);
            Enregistrer(Sda,Octet);
        end loop;
        Close(File);
        Ch:=new T_Cellule;
        Ch.all.Arbre:=new T_Noeud;
        Ch.all.Arbre.all.Gauche:=Null;
        Ch.all.Arbre.all.Droite:=Null;
        Ch.all.Arbre.all.Donnee:=0;
        Ch.all.Arbre.all.Cle:=-1;
        Ch.all.suivante:=Sda;
        Sda:=Ch;
    end Frequence;




    procedure Supprimer(Sda : in out T_Chaine; Frequence : in integer) is
    begin
        if Sda.all.Arbre.all.Donnee=Frequence then
            Sda:=Sda.all.suivante;
        else
            Supprimer(Sda.all.suivante, Frequence);
        end if;
    end Supprimer;

    --Renvoie la frequence et l'arbre du premier min rencontré.
    procedure Min_arbre(Sda:in T_Chaine;Min :in out integer;Arbre_min: in out T_Arbre) is
    begin
        if Sda.all.Arbre.all.Donnee<Min then
            Min:=Sda.all.Arbre.all.Donnee;
            Arbre_min:=Sda.all.Arbre;
        end if;
        if Sda.all.Suivante/=Null then
            Min_arbre(Sda.all.Suivante,Min,Arbre_min);
        end if;
    end Min_arbre;

    --Renvoie la Taille d'une chaine.
    function Taille(Sda: in T_Chaine) return integer is
    begin
        if Sda=Null then
            return 0;
        else
            return Taille(Sda.all.Suivante)+1;
        end if;
    end taille;

    --Calcul les deux min d'une chaine et supprime les arbres correspondant de la sda.
    procedure Deux_min(Sda: in out T_Chaine; arbre_min1: out T_Arbre; arbre_min2:out T_Arbre) is
        f:integer;
    begin
        arbre_min1:=Sda.all.Arbre;
        f:=Sda.all.arbre.all.Donnee;
        Min_arbre(Sda,f,arbre_min1);
        Supprimer(Sda,f);
        f:=Sda.all.arbre.all.Donnee;
        arbre_min2:=Sda.all.Arbre;
        Min_arbre(Sda,f,arbre_min2);
        Supprimer(Sda,f);
    end Deux_min;

    --Prend en entré un sda de noeud correspondant aux fréquences et renvoie l'ardre de Huffman.
    procedure Construction_Arbre(Sda: in out T_Chaine; Arbre : out T_Arbre) is
        Ch:T_Chaine;
        Arbre_min1:T_Arbre;
        Arbre_min2:T_Arbre;
    begin
        if Sda=Null then
            Put("La lca est vide");
        elsif Sda.all.suivante=Null then
            Arbre:=Sda.all.arbre;
        else
            Deux_Min(Sda,Arbre_min1,Arbre_min2);
            Ch:=new T_Cellule;
            Ch.all.Arbre:=new T_Noeud;
            Ch.all.Arbre.all.Gauche:=Arbre_min1;
            Ch.all.Arbre.all.Droite:=Arbre_min2;
            Ch.all.Arbre.all.Donnee:=Arbre_min1.all.Donnee+Arbre_min2.all.Donnee;
            Ch.all.suivante:=Sda;
            Sda:=Ch;
            Construction_Arbre(Sda,Arbre);

        end if;

    end Construction_Arbre;

    --Permet de construire la table à partir de l'arbre.
    procedure Construction_Table(Arbre: in T_Arbre;Table:out T_Table) is
        procedure Construire_table(Arbre: in T_Arbre;Table:out T_Table;Chaine:in Unbounded_String) is
        begin
            if Est_Feuille(Arbre) then
                Enregistrer(Table, Arbre.all.Cle, Chaine);
            else
                Construire_table(arbre.all.gauche,Table,Chaine & "0");
                Construire_table(arbre.all.droite,Table,Chaine & "1");
            end if;
        end construire_table;
    begin
        Construire_table(Arbre,Table,To_Unbounded_String("")) ;
    end Construction_Table;

    --Utilisation du package chaine pour gerer les "|" ne s'affichant pas sur l'arbre.
    package Suite_i is
            new Suite(Integer);
    use Suite_i;


    Procedure Affiche(Arbre: in T_Arbre; Alinea: in Integer; C : in out T_Suite )is
    begin
        Put("(");
        Put(Arbre.all.Donnee,1);
        Put(")");
        if Est_Feuille(Arbre) then
            Affiche_Caractere(Arbre.all.Cle);
        else
            new_Line;
            for i in 1..Alinea loop
                if Est_Present(C,i) then
                    put(" ");
                else
                    put("|");
                end if;
                put(7*" ");
            end loop;
            Put("\--0--");
            Supprimer(C,Alinea+1);
            Affiche(Arbre.all.Gauche,Alinea+1,C);
            New_Line;
            for i in 1..Alinea loop
                if Est_Present(C,i) then
                    put(" ");
                else
                    put("|");
                end if;
                put(7*" ");
            end loop;
            Put("\--1--");
            Enregistrer(C,Alinea+1);
            Affiche(Arbre.all.Droite,Alinea+1,C);
        end if;
    end Affiche;

    procedure Afficher_Arbre(Arbre:in T_Arbre) is
        C:T_Suite;
    begin
        Initialiser(C);
        Affiche(Arbre,0,C);
        Vider(C);
    end Afficher_Arbre;

    function Gauche(Arbre : in out T_Arbre) return T_Arbre is
    begin
        return Arbre.all.Gauche;
    end Gauche;

    function Droite(Arbre : in out T_Arbre) return T_Arbre is
    begin
        return Arbre.all.Droite;
    end Droite;

    procedure Reconstruction_Arbre(Arbre:out T_Arbre; Code : in Unbounded_String; Octet:in T_Tab_Oct;i_str:in out integer) is
        procedure Parcours(Arbre: in out T_Arbre; Code : in Unbounded_String; Octet:in T_Tab_Oct; i_str : in out integer;i_oct:in out integer) is
        begin
            if Element(Code,i_str)='0' and (Octet.Taille)>=i_oct then
                i_str:=i_str+1;
                Arbre.all.Donnee:=0;
                Arbre.all.Gauche:=New T_Noeud;
                Arbre.all.Droite:=New T_Noeud;
                Parcours(Arbre.all.Gauche, Code, Octet, i_str,i_oct);
                Parcours(Arbre.all.Droite, Code, Octet, i_str,i_oct);
            elsif Element(Code,i_str)='1' then
                Enregistrer_Feuille(Arbre,Octet.Tableau(i_oct));
                i_str:=i_str+1;
                i_oct:=i_oct+1;
            end if;
        end Parcours;

        i_oct:integer:=1;
    begin
        Arbre:=New T_Noeud;

        Parcours(Arbre, Code, Octet, i_str,i_oct);
    end Reconstruction_Arbre;
end Arbre;

