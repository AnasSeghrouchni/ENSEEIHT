-- Définition de structures de données associatives sous forme d'une table de hachage
-- (TH).
with LCA;
generic
    type T_Cle_t is private;
    type T_Donnee_t is private;
    Capacite : Integer;
    with function Fh(Cle : in T_Cle_t) return integer;


package TH is

    package LCA_t is
		new LCA (T_Cle =>T_Cle_t , T_Donnee => T_Donnee_t);
    use LCA_t;

	type T_TH is limited private;

	-- Initialiser une TH.  La TH est vide.
	procedure Initialiser_t(T: out T_TH) with
		Post => Est_Vide_t (T);


	-- Est-ce qu'une TH est vide ?
	function Est_Vide_t (T : T_TH) return Boolean;


	-- Obtenir le nombre d'éléments d'une TH.
	function Taille_t (T : in T_TH) return Integer with
		Post => Taille_t'Result >= 0
			and (Taille_t'Result = 0) = Est_Vide_t (T);


	-- Enregistrer une Donnée associée à une Clé dans une TH.
	-- Si la clé est déjà présente dans la TH, sa donnée est changée.
	procedure Enregistrer_t (T : in out T_TH ; Cle : in T_Cle_t ; Donnee : in T_Donnee_t) with
		Post => Cle_Presente_t (T, Cle) and (La_Donnee_t (T, Cle) = Donnee)   -- donnée insérée

				and (Cle_Presente_t (T, Cle)'Old or Taille_t (T) = Taille_t (T)'Old + 1);

	-- Supprimer la Donnée associée à une Clé dans une .
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la TH
	procedure Supprimer_t (T : in out T_TH ; Cle : in T_Cle_t) with
		Post =>  Taille_t (T) = Taille_t (T)'Old - 1 -- un élément de moins
			and not Cle_Presente_t (T, Cle);         -- la clé a été supprimée


	-- Savoir si une Clé est présente dans une Sda.
	function Cle_Presente_t (T : in T_TH ; Cle : in T_Cle_t) return Boolean;


	-- Obtenir la donnée associée à une Cle dans la TH.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la TH
	function La_Donnee_t (T : in T_TH ; Cle : in T_Cle_t) return T_Donnee_t;


	-- Supprimer tous les éléments d'une TH.
	procedure Vider_t (T : in out T_TH) with
            Post => Est_Vide_t (T);

    	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter_t(Cle : in T_Cle_t; Donnee: in T_Donnee_t);
    procedure Pour_Chaque_t (T : in T_TH);

private


    type T_TH is array(1..Capacite) of T_LCA;
end TH;
