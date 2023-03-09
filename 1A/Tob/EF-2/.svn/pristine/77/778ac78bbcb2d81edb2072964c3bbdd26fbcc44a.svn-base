package Logic;

public class Housing extends Stat {
	
	private float totalValue;
	
	public Housing() {
		this.baseValue = 10;
		this.currentValue = this.baseValue;
		this.totalValue = this.baseValue;
	}

	/**
	 * Appliquer tous les bonus liés à cette statistique.
	 * @param popSize La population accutelle
	 */
	public void appliquerBonus(long popSize) {
		this.currentValue = this.baseValue;
		for (Bonus bonus : bonuses) {
			this.currentValue += bonus.getStatic();
			this.currentValue = this.currentValue * (1 + bonus.getPercent()) ;
		}
		this.totalValue = this.currentValue;
		this.currentValue -= popSize * 0.01;
	}

	public float getTotalValue() { return this.totalValue; }
}
