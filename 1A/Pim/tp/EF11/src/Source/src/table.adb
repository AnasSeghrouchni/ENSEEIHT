with Ada.Unchecked_Deallocation;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with H_Exceptions; use H_Exceptions;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

package body Table is


    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Table);

    procedure Initialiser(Table: out T_Table) is
    begin
        Table:=Null;
    end Initialiser;


    function Est_Vide (Table : T_Table) return Boolean is
    begin
        return Table=Null;
    end Est_Vide;


    function Taille (Table : in T_Table) return Integer is
    begin
        if Table=Null then
            return 0;
        else
            return 1+Taille(Table.all.Prochain);
        end if;
    end Taille;


    function La_Position (Table : in T_Table ; Cle : in T_Octet) return integer is
    begin
        if Table.all.Cle=Cle then
            return 0;
        else
            return 1+La_Position(Table.all.Prochain,Cle);

        end if;
    end La_Position;


    function La_Donnee (Table : in T_Table ; Cle : in T_Octet) return Unbounded_String is
    begin
        if Table=Null then
            raise Table_Vide;
        elsif Table.all.Cle=Cle then
            return Table.all.Donnee;
        else
            return La_Donnee(Table.all.Prochain,Cle);
        end if;
    end La_Donnee;


    function La_Cle(Table : in T_Table ; Donnee : Unbounded_String ) return T_Octet is
    begin
        if Table=Null then
            raise Table_Vide;
        elsif Table.all.Donnee=Donnee then
            return Table.all.Cle;
        else
            return La_Cle(Table.all.Prochain,Donnee);
        end if;
    end La_Cle;


    function La_Cle(Table: in T_Table) return T_Octet is
    begin
        return Table.all.Cle;
    end La_Cle;


    function Cle_Presente (Table : in T_Table ; Cle : in T_Octet) return Boolean is
    begin
        if Table=Null then
            return False;
        elsif Table.all.Cle=Cle then
            return True;
        else
            return Cle_Presente(Table.all.Prochain,Cle);
        end if;
    end Cle_Presente;


    function Donnee_Presente (Table : in T_Table ; Donnee : in Unbounded_String) return Boolean is
             begin
        if Table=Null then
            return False;
        elsif Table.all.Donnee=Donnee then
            return True;
        else
            return Donnee_Presente(Table.all.Prochain,Donnee);
        end if;
    end Donnee_Presente;


    function Le_Prochain(Table:in T_Table) return T_Table is
    begin
        return Table.all.Prochain;
    end Le_Prochain;


    procedure Enregistrer (Table : in out T_Table ; Cle : in T_Octet ; Donnee : in Unbounded_String) is
    begin
        if Table=Null then
            Table:=New T_Cellule;
            Table.all.Cle:=Cle;
            Table.all.Donnee:=Donnee;
            Table.all.Prochain:=Null;
        elsif Table.all.Cle=Cle then
            Table.all.Donnee:=Donnee;
        else
            Enregistrer(Table.all.Prochain,Cle,Donnee);
        end if;
    end Enregistrer;


    procedure Supprimer (Table : in out T_Table ; Cle : in T_Octet) is
    begin
        if Table=Null then
            raise Table_vide;
        elsif Table.all.Cle=Cle then
            Table:=Table.all.Prochain;
        else
            Supprimer(Table.all.Prochain,Cle);
        end if;
    exception
        when others=>Null;
    end Supprimer;


    procedure Fin_au_Debut(Table: in out T_Table; Code: out Unbounded_String; Octet : out T_Octet) is
        Temporaire:Unbounded_String;
        C:T_Table;
        Pos:integer;
    begin
        Pos:=La_Position(Table,-1);
        Temporaire:=La_Donnee(Table,-1);
        Supprimer(Table,-1);
        C:=new T_Cellule;
        C.all.cle:=-1;
        C.all.Donnee:=Temporaire;
        C.all.Prochain:=Table;
        Table:=C;
        Code:=Table.all.Donnee;
        Octet :=0;
        Octet := (Octet * 2) or T_Octet(Pos/128 mod 2);
        Octet := (Octet * 2) or T_Octet(Pos/64 mod 2);
        Octet := (Octet * 2) or T_Octet(pos/32 mod 2);
        Octet := (Octet * 2) or T_Octet(pos/16 mod 2);
        Octet := (Octet * 2) or T_Octet(pos/8 mod 2);
        Octet := (Octet * 2) or T_Octet(pos/4 mod 2);
        Octet := (Octet * 2) or T_Octet(pos/2 mod 2);
        Octet := (Octet * 2) or T_Octet(pos mod 2);
    end Fin_au_Debut;


    procedure Doubler_la_fin(Table: in out T_Table) is
    begin
        if Table=Null then
            raise Table_Vide;
        elsif Table.all.Prochain=Null then
            Table.all.Prochain:=New T_Cellule;
            Table.all.Prochain.all.Cle:=Table.all.Cle;
            Table.all.Prochain.all.Donnee:=Table.all.Donnee;
        else
            Doubler_la_fin(Table.all.Prochain);
        end if ;
    end Doubler_la_fin;



    procedure Vider (Table : in out T_Table) is
    begin
        if Table /= Null then
            Vider (Table.all.Prochain);
            Free (Table);
        else
            Null;
        end if;
    end Vider;


    Procedure Affiche_caractere(Octet : in T_Octet) is
    Begin
        Put("'");
        if Octet=10 then
            Put("\n");
        elsif Octet=-1 then
            Put("\$");
        elsif Octet=32 then
            Put(" ");
        else
            Put(Character'Val(Octet));
        end if;
        Put("'");
    end Affiche_caractere;


    procedure Affiche_Couple(Octet : in T_Octet; Str : in Unbounded_String) is
    begin
        Affiche_caractere(Octet);
        Put("-->");
        Put(To_String(Str));
        New_Line;
    End Affiche_Couple;


    procedure Affiche_Table (Table : in T_Table) is
    begin
        if Table=Null then
            Null;
        else
            Affiche_Couple(Table.all.Cle,Table.all.Donnee);
            Affiche_Table(Table.all.Prochain);
        end if;
    exception
        when others =>Affiche_Table(Table.all.Prochain);
    end Affiche_Table;


end Table;