/**
 * Définition d'un agenda individuel.
 */
public class AgendaIndividuel extends AgendaAbstrait {

	private String[] rendezVous;	// le texte des rendezVous


	/**
	 * Créer un agenda vide (avec aucun rendez-vous).
	 *
	 * @param nom le nom de l'agenda
	 * @throws IllegalArgumentException si nom nul ou vide
	 */
	public AgendaIndividuel(String nom) throws IllegalArgumentException{
		super(nom);
		this.rendezVous = new String[Agenda.CRENEAU_MAX + 1];
			// On gaspille une case (la première qui ne sera jamais utilisée)
			// mais on évite de nombreux « creneau - 1 »
	}


	@Override
	public void enregistrer(int creneau, String rdv) throws IllegalArgumentException,CreneauInvalideException,OccupeException{
		if (rdv==null || rdv.length()<=1) {
			throw new IllegalArgumentException("Attention vous etes entrain de rentrer le vide");
		}
		else{
		super.verifierCreneauValide(creneau);
		if (this.rendezVous[creneau]==null) {
		this.rendezVous[creneau] = rdv;}
		else {
			throw new OccupeException("La date est déjà occupée");
		}
		}
	}


	@Override
	public boolean annuler(int creneau) throws CreneauInvalideException{
		super.verifierCreneauValide(creneau);
		boolean modifie = this.rendezVous[creneau] != null;
		this.rendezVous[creneau] = null;
		return modifie;
	}


	@Override
	public String getRendezVous(int creneau) throws LibreException,CreneauInvalideException{
		super.verifierCreneauValide(creneau);
		if (this.rendezVous[creneau]==null) {
			throw new LibreException("Vous n'avez rien ce jour là");
		}
		{
		return this.rendezVous[creneau];
		}
	}


}
