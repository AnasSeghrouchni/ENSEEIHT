package Logic;


import java.awt.Color;

public class Bonus  {

	/* Toutes les types de bonus possibles*/
	public enum BonusStat {
		FOOD,
		HOUSING,
		HAPPINESS,
		PRODUCTION
	}


	/* Statistique liée au bonus */
	BonusStat stat;

	/* Valeur constante du bonus */
	int staticUpgrade = 0;

	/* Valeur en pourcentage du bonus */
	float percentUpgrade = 0;

	public Bonus(BonusStat stat, int staticUpgrade, float percentUpgrade) {
		this.stat = stat;
		this.staticUpgrade = staticUpgrade;
		this.percentUpgrade = percentUpgrade;
	}

	public Bonus(BonusStat stat, int staticUpgrade) {
		this.stat = stat;
		this.staticUpgrade = staticUpgrade;
	}

	public Bonus(BonusStat stat, float percentUpgrade) {
		this.stat = stat;
		this.percentUpgrade = percentUpgrade;
	}

	/** Avoir la statistique liée au bonus
	 * @return BonusStat la stat liée au bonus
	 */
	public BonusStat getBonusStat() { return  this.stat; }

	/** Avoir la couleur liée au bonus
	 * @return color la couleur au bonus
	 */
	public Color getBonusColor() {
		switch (this.stat) {
			case PRODUCTION :
				return Color.ORANGE;
			case HAPPINESS :
				return Color.PINK;
			case FOOD :
				return Color.green;
			case HOUSING :
				return Color.yellow;
		};
		return null;
	}

	/**
	 * Fournie la valeur constante du bonus.
	 * 
	 * @return int StaticUpgrade
	 */
	public int getStatic() {
		return this.staticUpgrade;
	}

	/**
	 * Fournie la valeur en pourcentage du bonus.
	 * 
	 * @return float percentUpgrade
	 */
	public float getPercent() {
		return this.percentUpgrade;
	}
}
