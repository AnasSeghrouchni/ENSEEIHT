package editeur.commande;

import java.io.Console;

import editeur.Ligne;

/** Ajouter un caractère à la fin de la ligne.
 * @author	Xavier Crégut
 * @version	1.4
 */
public class CommandeAjouterFin extends CommandeLigne
{

	/** Initialiser la ligne sur laquelle travaille
	 * cette commande.
	 * @param l la ligne
	 */
	//@ requires l != null;	// la ligne doit être définie
	public CommandeAjouterFin(Ligne l) {
		super(l);
	}

	public void executer() {
		String texte = Console.readLine("Texte à insérer : ");
		for (int i = 0; i < texte.length(); i++) {
			ligne.ajouterFin(texte.charAt(i));
		}
	}

	public boolean estExecutable() {
		return true;
	}

}
