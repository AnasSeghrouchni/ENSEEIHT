with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Integer_Text_IO;         use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;           use Ada.Float_Text_IO;
with Ada.Unchecked_Deallocation;

package body Vecteurs_Creux is


	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Vecteur_Creux);


	procedure Initialiser (V : out T_Vecteur_Creux) is
	begin
        V:=Null;
	end Initialiser;


	procedure Detruire (V: in out T_Vecteur_Creux) is
	begin
        if V/= Null then
            Detruire(V.all.Suivant);
            Free (V);
        else
            Null;

        end if;
	end Detruire;


    function Est_Nul (V : in T_Vecteur_Creux) return Boolean is
	begin
		return V=Null;
	end Est_Nul;


	function Composante_Recursif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
    begin
        if V=Null then
            return 0.0;
        else

        if V.all.Indice=Indice then
            return V.all.Valeur;
        elsif V.all.Indice>Indice then
            return 0.0;
        else
            return Composante_Recursif(V.all.Suivant,Indice);
            end if;
        end if;

	end Composante_Recursif;


    function Composante_Iteratif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
            C:T_Vecteur_Creux;

    begin
        C:=V;
        if C=Null then
            return 0.0;
        else

            while Indice>C.all.Indice loop
                C:=C.all.Suivant;
            end loop;
            if C.all.Indice=Indice then
                return C.all.Valeur;
            else
                return 0.0;
            end if;
        end if;


	end Composante_Iteratif;


	procedure Modifier (V : in out T_Vecteur_Creux ;
				       Indice : in Integer ;
                     Valeur : in Float ) is
        C:T_Vecteur_Creux;
    begin
        if Valeur/=0.0 then
            if V=Null then
                V:= New T_Cellule;
                V.all.Indice:=Indice;
                V.all.Valeur:=Valeur;
                V.all.Suivant:=Null;
            else
                if V.all.Indice=Indice then
                    V.all.Valeur:=Valeur;
                elsif V.all.Indice>Indice then
                    C:= new T_Cellule;
                    C.all.Indice:=Indice;
                    C.all.Valeur:= Valeur;
                    C.all.Suivant:=V;
                    V:=C;
                else
                    Modifier(V.all.Suivant, Indice,Valeur);
                end if;
            end if;
        else
            if V=Null then
                Null;
            else
                if V.all.Indice=Indice then
                    V:=V.Suivant;
                elsif V.all.Indice>Indice then
                    Null;
                else
                    Modifier(V.all.suivant, Indice,Valeur);
                end if;
            end if;
        end if;
    end Modifier;


	function Sont_Egaux_Recursif (V1, V2 : in T_Vecteur_Creux) return Boolean is
	begin
        if V1=Null and V2=Null then
            return true;
        else
            return V1.all.Indice=V2.all.Indice and
                    V1.all.Valeur=V2.all.Valeur and Sont_Egaux_Recursif(V1.all.Suivant,V2.all.Suivant);
        end if;

	end Sont_Egaux_Recursif;


    function Sont_Egaux_Iteratif (V1, V2 : in T_Vecteur_Creux) return Boolean is
        C1,C2:T_Vecteur_Creux;
    begin
        C1:=V1;
        C2:=V2;
        if C1=Null and C2=Null then
            return true;
        else
		while C1/=Null and C2/=Null and C1.all.Indice=C2.all.Indice and
                C1.all.Valeur=C2.all.Valeur loop
            C1:=C1.all.Suivant;
            C2:=C2.all.suivant;
            end loop;
            return C1=Null and C2=Null;
        end if;



	end Sont_Egaux_Iteratif;


	procedure Additionner (V1 : in out T_Vecteur_Creux; V2 : in T_Vecteur_Creux) is
	begin
        if V1=Null then
            V1:=V2;
        else
            if V1.all.Indice=V2.all.Indice then
                V1.all.Valeur:=V1.all.Valeur+V2.all.Valeur;
                Additionner(V1.all.Suivant,V2.all.Suivant);
            elsif V1.all.Indice>V2.all.Indice then
                Modifier(V1,V2.all.Indice,V2.all.Valeur);
                Additionner(V1,V2.all.Suivant);
            else
                Additionner(V1.all.Suivant,V2);
            end if;
        end if;

	end Additionner;


	function Norme2 (V : in T_Vecteur_Creux) return Float is
	begin
		return 0.0;	-- TODO : à changer
	end Norme2;


	Function Produit_Scalaire (V1, V2: in T_Vecteur_Creux) return Float is
	begin
		return 0.0;	-- TODO : à changer
	end Produit_Scalaire;


	procedure Afficher (V : T_Vecteur_Creux) is
	begin
		if V = Null then
			Put ("--E");
		else
			-- Afficher la composante V.all
			Put ("-->[ ");
			Put (V.all.Indice, 0);
			Put (" | ");
			Put (V.all.Valeur, Fore => 0, Aft => 1, Exp => 0);
			Put (" ]");

			-- Afficher les autres composantes
			Afficher (V.all.Suivant);
		end if;
	end Afficher;


	function Nombre_Composantes_Non_Nulles (V: in T_Vecteur_Creux) return Integer is
	begin
		if V = Null then
			return 0;
		else
			return 1 + Nombre_Composantes_Non_Nulles (V.all.Suivant);
		end if;
	end Nombre_Composantes_Non_Nulles;


end Vecteurs_Creux;