-- Définition de structures de donnÃ©es associatives sous forme d'une liste
-- chaÃ®nÃ©e associative (LCA).
generic
	type T_Cle is private;
	type T_Donnee is private;

package LCA is

	type T_LCA is limited private;

	-- Initialiser une Sda.  La Sda est vide.
	procedure Initialiser(Sda: out T_LCA) with
		Post => Est_Vide (Sda);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide (Sda : T_LCA) return Boolean;


	-- Obtenir le nombre d'Ã©lÃ©ments d'une Sda.
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);


	-- Enregistrer une DonnÃ©e associÃ©e Ã  une ClÃ© dans une Sda.
	-- Si la clÃ© est dÃ©jÃ  prÃ©sente dans la Sda, sa donnÃ©e est changÃ©e.
	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) with
		Post => Cle_Presente (Sda, Cle) and (La_Donnee (Sda, Cle) = Donnee)   -- donnÃ©e insÃ©rÃ©e
				and (not (Cle_Presente (Sda, Cle)'Old) or Taille (Sda) = Taille (Sda)'Old)
				and (Cle_Presente (Sda, Cle)'Old or Taille (Sda) = Taille (Sda)'Old + 1);

	-- Supprimer la DonnÃ©e associÃ©e Ã  une ClÃ© dans une Sda.
	-- Exception : Cle_Absente_Exception si ClÃ© n'est pas utilisÃ©e dans la Sda
	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 -- un Ã©lÃ©ment de moins
			and not Cle_Presente (Sda, Cle);         -- la clÃ© a Ã©tÃ© supprimÃ©e


	-- Savoir si une ClÃ© est prÃ©sente dans une Sda.
	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean;


	-- Obtenir la donnÃ©e associÃ©e Ã  une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si ClÃ© n'est pas utilisÃ©e dans l'Sda
	function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee;


	-- Supprimer tous les Ã©lÃ©ments d'une Sda.
	procedure Vider (Sda : in out T_LCA) with
		Post => Est_Vide (Sda);


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter (Cle : in T_Cle; Donnee: in T_Donnee);
	procedure Pour_Chaque (Sda : in T_LCA);

private

   type T_Cellule;

   type T_LCA is access T_Cellule;

   type T_Cellule is record
      Cle : T_Cle;
      Donnee : T_Donnee;
      Suivante : T_LCA;
   end record;

end LCA;