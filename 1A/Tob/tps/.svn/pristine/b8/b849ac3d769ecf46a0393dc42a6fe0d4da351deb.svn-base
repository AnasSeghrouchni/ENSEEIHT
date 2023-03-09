/**
 * AgendaAbstrait factorise la définition du nom et de l'accesseur associé.
 */
public abstract class AgendaAbstrait extends ObjetNomme implements Agenda {

	/**
	 * Initialiser le nom de l'agenda.
	 *
	 * @param nom le nom de l'agenda
	 * @throws IllegalArgumentException si nom n'a pas au moins un caractère
	 */
	public AgendaAbstrait(String nom) throws IllegalArgumentException{
		super(nom);
	}
	/** Verifie si le creneau entré en parametre est un creneau valide.
	 * @param creneau le creneau à verifier.
	 * @throws CreneauInvalideException si le creneau n'est pas valide.
	*/
	public void verifierCreneauValide(int creneau) throws CreneauInvalideException {
		if ( creneau<1 || creneau>366 ) {
			throw new CreneauInvalideException("Attention, le creneau que vous avez rentré n'a aucun sens");
		}
		
	}
}
