package Logic;

public class Happiness extends Stat {

	
	public Happiness() {
		this.baseValue = 50;
		this.currentValue = this.baseValue;
	}

	/**
	 * Appliquer tous les bonus liés à cette statistique.
	 * @param housingRatio Le ratio d'habitation disponible
	 */
	public void appliquerBonus(float housingRatio) {
		this.currentValue = this.baseValue;
		for (Bonus bonus : bonuses) {
			this.currentValue += bonus.getStatic();
			this.currentValue = this.currentValue * (1 + bonus.getPercent());
		}
		if (housingRatio < 0) {
			this.currentValue +=  housingRatio;
		}
		if (this.currentValue > 100) {
			this.currentValue = 100;
		} else if (this.currentValue < 0) {
			this.currentValue = 0;
		}
	}
	
}
