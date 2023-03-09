/***
 * Définition d'un type cellule permettant le structure chainée.
 * @author aseghrou
 *
 */
public class Cellule {
	int entier;
	Cellule suivant;
	
	/**
	 * Constructeur de la cellule.
	 * @param contient
	 * @param next
	 */
	public Cellule(int contient, Cellule next) {
		this.entier=contient;
		this.suivant=next;
	}

}
