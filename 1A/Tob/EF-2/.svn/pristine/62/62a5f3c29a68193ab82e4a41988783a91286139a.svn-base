package Logic;
import java.util.ArrayList; // import the ArrayList class

public abstract class Stat {
	/**
	 * Tous les bonus liés à cette statistique.
	 */
	protected ArrayList<Bonus> bonuses = new ArrayList<>();

	/**
	 * Valeur actuelle de la statistique.
	 */
	protected float currentValue;

	/**
	 *  Valeur de base
	 */
	protected float baseValue;
	/**
	 * Appliquer tous les bonus liés à cette statistique.
	 */
	public void appliquerBonus() {
		this.currentValue = baseValue;
		for (Bonus bonus : bonuses) {
			this.currentValue += bonus.getStatic();
			this.currentValue = this.currentValue * (1 + bonus.getPercent());
		}
	}

	/**
	 * Récupérer la valeur courante de la statistique.
	 */
	public float getCurrentValue() {
		return this.currentValue;
	}

	/** Ajouter un bonus à la liste des bonus de la stat
	 * @param bonus le bonus à ajouter
	 */
	public void addBonus(Bonus bonus) {
		this.bonuses.add(bonus);
	}
}
