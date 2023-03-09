with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
	--! Les Unbounded_String ont une capacité variable, contrairement au String
	--! pour lesquelles une capacité doit être fixée.
with TH;

procedure Test_TH is

	package TH_String_Integer is
		new TH (T_Cle_t => Unbounded_String, T_Donnee_t => Integer, Capacite=>11, Fh=>Length);
	use TH_String_Integer;


	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;

	-- Utiliser & entre String à gauche et Unbounded_String à droite.  Des
	-- guillemets sont ajoutées autour de la Unbounded_String
	-- Il s'agit d'un masquage de l'opérteur & défini dans Strings.Unbounded
	function "&" (Left: String; Right: Unbounded_String) return String is
	begin
		return Left & Avec_Guillemets (Right);
	end;


	-- Surcharge l'opérateur unaire "+" pour convertir une String
	-- en Unbounded_String.
	-- Cette astuce permet de simplifier l'initialisation
	-- de cles un peu plus loin.
	function "+" (Item : in String) return Unbounded_String
		renames To_Unbounded_String;


	-- Afficher une Unbounded_String et un entier.
	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Sda.
	procedure Afficher is
		new Pour_Chaque_t (Afficher);


	Nb_Cles : constant Integer := 7;
	Cles : constant array (1..Nb_Cles) of Unbounded_String
			:= (+"un", +"deux", +"trois", +"quatre", +"cinq",
				+"quatre-vingt-dix-neuf", +"vingt-et-un");
	Inconnu : constant  Unbounded_String := To_Unbounded_String ("Inconnu");

	Donnees : constant array (1..Nb_Cles) of Integer
			:= (1, 2, 3, 4, 5, 99, 21);
	Somme_Donnees : constant Integer := 135;
	Somme_Donnees_Len4 : constant Integer := 7; -- somme si Length (Cle) = 4
	Somme_Donnees_Q: constant Integer := 103; -- somme si initiale de Cle = 'q'


	-- Initialiser l'annuaire avec les Donnees et Cles ci-dessus.
	-- Attention, c'est à l'appelant de libérer la mémoire associée en
	-- utilisant Vider_t.
	-- Si Bavard est vrai, les insertions sont tracées (affichées).
	procedure Construire_Exemple_Sujet (Annuaire : out T_TH; Bavard: Boolean := False) is
	begin
		Initialiser_t (Annuaire);
		pragma Assert (Est_Vide_t (Annuaire));
		pragma Assert (Taille_t (Annuaire) = 0);

		for I in 1..Nb_Cles loop
			Enregistrer_t (Annuaire, Cles (I), Donnees (I));

			if Bavard then
				Put_Line ("Après insertion de la clé " & Cles (I));
				Afficher (Annuaire); New_Line;
			else
				null;
			end if;

			pragma Assert (not Est_Vide_t (Annuaire));
			pragma Assert (Taille_t (Annuaire) = I);

			for J in 1..I loop
				pragma Assert (La_Donnee_t (Annuaire, Cles (J)) = Donnees (J));
			end loop;

			for J in I+1..Nb_Cles loop
				pragma Assert (not Cle_Presente_t (Annuaire, Cles (J)));
			end loop;

		end loop;
	end Construire_Exemple_Sujet;


	procedure Tester_Exemple_Sujet is
		Annuaire : T_TH;
	begin
		Construire_Exemple_Sujet (Annuaire, True);
		Vider_t (Annuaire);
	end Tester_Exemple_Sujet;


	-- Tester suppression en commençant par les derniers éléments ajoutés
	procedure Tester_Supprimer_Inverse is
		Annuaire : T_TH;
	begin
		Put_Line ("=== Tester_Supprimer_Inverse..."); New_Line;

		Construire_Exemple_Sujet (Annuaire);

		for I in reverse 1..Nb_Cles loop

			Supprimer_t (Annuaire, Cles (I));

			Put_Line ("Après suppression de " & Cles (I) & " :");
			Afficher (Annuaire); New_Line;

			for J in 1..I-1 loop
				pragma Assert (Cle_Presente_t (Annuaire, Cles (J)));
				pragma Assert (La_Donnee_t (Annuaire, Cles (J)) = Donnees (J));
			end loop;

			for J in I..Nb_Cles loop
				pragma Assert (not Cle_Presente_t (Annuaire, Cles (J)));
			end loop;
		end loop;

		Vider_t (Annuaire);
	end Tester_Supprimer_Inverse;


	-- Tester suppression en commençant les les premiers éléments ajoutés
	procedure Tester_Supprimer is
		Annuaire : T_TH;
	begin
		Put_Line ("=== Tester_Supprimer..."); New_Line;

		Construire_Exemple_Sujet (Annuaire);

		for I in 1..Nb_Cles loop
			Put_Line ("Suppression de " & Cles (I) & " :");

			Supprimer_t (Annuaire, Cles (I));

			Afficher (Annuaire); New_Line;

			for J in 1..I loop
				pragma Assert (not Cle_Presente_t (Annuaire, Cles (J)));
			end loop;

			for J in I+1..Nb_Cles loop
				pragma Assert (Cle_Presente_t (Annuaire, Cles (J)));
				pragma Assert (La_Donnee_t (Annuaire, Cles (J)) = Donnees (J));
			end loop;
		end loop;

		Vider_t (Annuaire);
	end Tester_Supprimer;


	procedure Tester_Supprimer_Un_Element is

		-- Tester supprimer sur un élément, celui à Indice dans Cles.
		procedure Tester_Supprimer_Un_Element (Indice: in Integer) is
			Annuaire : T_TH;
		begin
			Construire_Exemple_Sujet (Annuaire);

			Put_Line ("Suppression de " & Cles (Indice) & " :");
			Supprimer_t (Annuaire, Cles (Indice));

			Afficher (Annuaire); New_Line;

			for J in 1..Nb_Cles loop
				if J = Indice then
					pragma Assert (not Cle_Presente_t (Annuaire, Cles (J)));
				else
					pragma Assert (Cle_Presente_t (Annuaire, Cles (J)));
				end if;
			end loop;

			Vider_t (Annuaire);
		end Tester_Supprimer_Un_Element;

	begin
		Put_Line ("=== Tester_Supprimer_Un_Element..."); New_Line;

		for I in 1..Nb_Cles loop
			Tester_Supprimer_Un_Element (I);
		end loop;
	end Tester_Supprimer_Un_Element;


	procedure Tester_Remplacer_Un_Element is

		-- Tester Enregistrer_t sur un élément présent, celui à Indice dans Cles.
		procedure Tester_Remplacer_Un_Element (Indice: in Integer; Nouveau: in Integer) is
			Annuaire : T_TH;
		begin
			Construire_Exemple_Sujet (Annuaire);

			Put_Line ("Remplacement de " & Cles (Indice)
					& " par " & Integer'Image(Nouveau) & " :");
			Enregistrer_t (Annuaire, Cles (Indice), Nouveau);

			Afficher (Annuaire); New_Line;

			for J in 1..Nb_Cles loop
				pragma Assert (Cle_Presente_t (Annuaire, Cles (J)));
				if J = Indice then
					pragma Assert (La_Donnee_t (Annuaire, Cles (J)) = Nouveau);
				else
					pragma Assert (La_Donnee_t (Annuaire, Cles (J)) = Donnees (J));
				end if;
			end loop;

			Vider_t (Annuaire);
		end Tester_Remplacer_Un_Element;

	begin
		Put_Line ("=== Tester_Remplacer_Un_Element..."); New_Line;

		for I in 1..Nb_Cles loop
			Tester_Remplacer_Un_Element (I, 0);
			null;
		end loop;
	end Tester_Remplacer_Un_Element;


	procedure Tester_Supprimer_Erreur is
		Annuaire : T_TH;
	begin
		begin
			Put_Line ("=== Tester_Supprimer_Erreur..."); New_Line;

			Construire_Exemple_Sujet (Annuaire);
			Supprimer_t (Annuaire, Inconnu);

		exception
			when Cle_Absente_Exception =>
				null;
			when others =>
				pragma Assert (False);
		end;
		Vider_t (Annuaire);
	end Tester_Supprimer_Erreur;


	procedure Tester_La_Donnee_Erreur is
		Annuaire : T_TH;
		Inutile: Integer;
	begin
		begin
			Put_Line ("=== Tester_La_Donnee_Erreur..."); New_Line;

			Construire_Exemple_Sujet (Annuaire);
			Inutile := La_Donnee_t (Annuaire, Inconnu);

		exception
			when Cle_Absente_Exception =>
				null;
			when others =>
				pragma Assert (False);
		end;
		Vider_t (Annuaire);
	end Tester_La_Donnee_Erreur;


	procedure Tester_Pour_Chaque_t is
		Annuaire : T_TH;

		Somme: Integer;

		procedure Sommer (Cle: Unbounded_String; Donnee: Integer) is
		begin
			Put (" + ");
			Put (Donnee, 2);
			New_Line;

			Somme := Somme + Donnee;
		end;

		procedure Sommer is
			new Pour_Chaque_t (Sommer);

	begin
		Put_Line ("=== Tester_Pour_Chaque_t..."); New_Line;
		Construire_Exemple_Sujet(Annuaire);
		Somme := 0;
		Sommer (Annuaire);
		pragma Assert (Somme = Somme_Donnees);
		Vider_t(Annuaire);
		New_Line;
	end Tester_Pour_Chaque_t;


	procedure Tester_Pour_Chaque_t_Somme_Si_Cle_Commence_Par_Q is
		Annuaire : T_TH;

		Somme: Integer;

		procedure Sommer_Cle_Commence_Par_Q (Cle: Unbounded_String; Donnee: Integer) is
		begin
			if To_String (Cle) (1) = 'q' then
				Put (" + ");
				Put (Donnee, 2);
				New_Line;

				Somme := Somme + Donnee;
			else
				null;
			end if;
		end;

		procedure Sommer is
			new Pour_Chaque_t (Sommer_Cle_Commence_Par_Q);

	begin
		Put_Line ("=== Tester_Pour_Chaque_t_Somme_Si_Cle_Commence_Par_Q..."); New_Line;
		Construire_Exemple_Sujet(Annuaire);
		Somme := 0;
		Sommer (Annuaire);
		pragma Assert (Somme = Somme_Donnees_Q);
		Vider_t(Annuaire);
		New_Line;
	end Tester_Pour_Chaque_t_Somme_Si_Cle_Commence_Par_Q;



	procedure Tester_Pour_Chaque_t_Somme_Len4_Erreur is
		Annuaire : T_TH;

		Somme: Integer;

		procedure Sommer_Len4_Erreur (Cle: Unbounded_String; Donnee: Integer) is
			Nouvelle_Exception: Exception;
		begin
			if Length (Cle) = 4 then
				Put (" + ");
				Put (Donnee, 2);
				New_Line;

				Somme := Somme + Donnee;
			else
				raise Nouvelle_Exception;
			end if;
		end;

		procedure Sommer is
			new Pour_Chaque_t (Sommer_Len4_Erreur);

	begin
		Put_Line ("=== Tester_Pour_Chaque_t_Somme_Len4_Erreur..."); New_Line;
		Construire_Exemple_Sujet(Annuaire);
		Somme := 0;
		Sommer (Annuaire);
		pragma Assert (Somme = Somme_Donnees_Len4);
		Vider_t(Annuaire);
		New_Line;
	end Tester_Pour_Chaque_t_Somme_Len4_Erreur;



begin
	Tester_Exemple_Sujet;
	Tester_Supprimer_Inverse;
	Tester_Supprimer;
	Tester_Supprimer_Un_Element;
	Tester_Remplacer_Un_Element;
	Tester_Supprimer_Erreur;
	Tester_La_Donnee_Erreur;
	Tester_Pour_Chaque_t;
	Tester_Pour_Chaque_t_Somme_Si_Cle_Commence_Par_Q;
	Tester_Pour_Chaque_t_Somme_Len4_Erreur;
	Put_Line ("Fin des tests : OK.");
end Test_TH;
