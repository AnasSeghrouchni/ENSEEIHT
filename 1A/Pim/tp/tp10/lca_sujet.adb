with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;



procedure lca_sujet is

    package LCA_String is
		new LCA (T_Cle =>Unbounded_String , T_Donnee => Integer);
    use LCA_String;

procedure Ecrire(Cle :in  Unbounded_String; Donnee : In Integer) is
    begin
        Put(To_String(Cle));
        Put(" : ");
        Put(Donnee);
        New_Line;
    end Ecrire;

    procedure Afficher is new Pour_Chaque (Ecrire);

    l:T_LCA;
begin
    Initialiser(L);
    Enregistrer (l,To_Unbounded_String("un"),1);
    Enregistrer(l,To_Unbounded_String("deux"),2);
    Afficher(l);
    Vider(l);
end lca_sujet;
