package body Suite is
    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Suite);

    procedure Vider (Sda : in out T_Suite) is
    begin
        if Sda /= Null then
            Vider (Sda.all.Suivante);
            Free (Sda);
        end if;
    end Vider;


    Procedure Initialiser(Sda: out T_Suite) is
    begin
        Sda:=Null;
    end;


    function Est_Vide(Sda : in T_Suite) return Boolean is
    begin
        return Sda=Null;
    end;

    procedure Enregistrer(Sda : in out T_Suite; Cle : in T_Cle) is
    begin
        if Sda=Null then
            Sda:=New T_Cellule;
            Sda.all.Cle:=Cle;
        else
            Enregistrer(Sda.all.Suivante,Cle);
        end if;
    end Enregistrer;

    procedure Supprimer(Sda : in out T_Suite; Cle : in T_Cle) is
    begin
        if Sda=Null then
            Null;
        else
            if Sda.all.Cle=Cle then
                Sda:=Sda.all.Suivante;
            else
                Supprimer(Sda.all.Suivante,Cle);
            end if;
        end if;
    end Supprimer;

    function Est_Present(Sda:in T_Suite;Cle:in T_Cle) return Boolean is
    begin
        if Sda=Null then
            return False;
        elsif sda.all.Cle=Cle then
            return True;
        else
            return Est_Present(Sda.all.Suivante,Cle);
        end if;
    end Est_Present;




end Suite;