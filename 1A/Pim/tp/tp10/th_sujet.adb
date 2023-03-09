with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TH;


procedure th_sujet is


    package TH_string is new TH (T_Cle_t=>Unbounded_String,
                                 T_Donnee_t=>Integer,
                                 Capacite=>11,
                                 Fh=>Length);
    use TH_string;


    procedure Ecrire(Cle :in  Unbounded_String; Donnee : In Integer) is
    begin
        Put(To_String(Cle));
        Put(" : ");
        Put(Donnee);
        New_Line;
    end Ecrire;

    procedure Afficher_t is new Pour_Chaque_t(Ecrire);
    T :T_TH;

    begin
        Initialiser_t(T);
        Enregistrer_t(T,To_Unbounded_String("un"),1);
        Enregistrer_t(T,To_Unbounded_String("deux"),2);
        Enregistrer_t(T,To_Unbounded_String("trois"),3);
        Enregistrer_t(T,To_Unbounded_String("quatre"),4);
        Enregistrer_t(T,To_Unbounded_String("cinq"),5);
        Enregistrer_t(T,To_Unbounded_String("quatre-vingt-dix-neuf"),99);
        Enregistrer_t(T,To_Unbounded_String("vingt-et-un"),21);
        Afficher_t(T);
    end th_sujet;