with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body TH is


    procedure Initialiser_t (T : out T_TH) is
    begin
        for i in 1..Capacite loop
            Initialiser(T(i));
        end loop;


    end Initialiser_t;

    function Est_Vide_t (T: in T_TH) return Boolean is
            i :integer:=1;
    begin
        while i<Capacite and Est_Vide(T(i)) loop
            i:=i+1;
        end loop;
        return Est_Vide(T(i));
    end Est_Vide_t;

    function Taille_t (T: in T_TH) return Integer is
        Taille_Tableau:Integer:=0;
    begin
        for i in 1..Capacite loop
            Taille_Tableau:= Taille_Tableau+Taille(T(i));
        end loop;
        return Taille_Tableau;
    end Taille_t;

    procedure Enregistrer_t(T : in out T_TH ; Cle : in T_Cle_t ; Donnee : in T_Donnee_t) is
        cle_t:integer;
    begin
        if Fh(Cle)>Capacite then
            cle_t:=(Fh(Cle)) mod Capacite+1;
        else
            cle_t:=(Fh(Cle));
        end if;
                Enregistrer(T(cle_t),Cle,Donnee);
    end Enregistrer_t;

    procedure Supprimer_t(T : in out T_TH ; Cle : in T_Cle_t) is
        cle_t:integer;
    begin
         if Fh(Cle)>Capacite then
            cle_t:=(Fh(Cle)) mod Capacite+1;
        else
            cle_t:=(Fh(Cle));
        end if;
        Supprimer(T(cle_t),Cle);
    end Supprimer_t;

    function Cle_Presente_t(T : in T_TH; Cle: in T_Cle_t) return Boolean is
        i:integer:=1;
    begin
        while i<Capacite and not(Cle_Presente(T(i),Cle)) loop
            i:=i+1;
        end loop;
        return Cle_Presente(T(i),Cle);
    end Cle_Presente_t;

    function La_Donnee_t (T : in T_TH ; Cle : in T_Cle_t) return T_Donnee_t is
        cle_t: integer;
    begin
         if Fh(Cle)>Capacite then
            cle_t:=(Fh(Cle)) mod Capacite+1;
        else
            cle_t:=(Fh(Cle));
        end if;
        return La_Donnee(T(cle_t), Cle);
    end La_Donnee_t;

    procedure Vider_t(t:in out T_TH) is
    begin

        for i in 1..Capacite loop
            Vider(T(i));
        end loop;
    end Vider_t;



    procedure Pour_Chaque_t(T: in T_TH) is

        procedure Pour_Chaque_tableau is new Pour_Chaque (Traiter => Traiter_t);

    begin

        for i in 1..Capacite loop
            Pour_Chaque_tableau(T(i));
        end loop;
    end Pour_Chaque_t;

end TH;
