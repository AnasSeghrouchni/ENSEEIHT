package Logic;

/**
 * Ensemble des objets achetables dans le jeu
 * 
 * @author nohehf
 *
 */
public class Purchasable {


	public enum BATIMENT {
		COMMUN,UNIQUE,HDV
	}
	
	private final String name;
	private final Bonus[] bonuses; //ensemble des bonus donnés par l'achat
	private final int price; //prix d'achat en production d'un achetable
	private final Run.Era era; //ere minimum pour débloquer
	private boolean isPurchased;
	private final BATIMENT type; // catégorie de bâtiment

	
	public Purchasable(String name, Bonus[] bonuses,int price, BATIMENT type) {
		this.name = name;
		this.bonuses = bonuses;
		this.price = price;
		this.isPurchased = false;
		this.era = Run.Era.ANTIQUITY;
		this.type = type;
	}
	
	public String getName() {
		return this.name;
	}
	
	public Bonus[] getBonus() {
		return this.bonuses;
	}
	
	public int getPrice() {
		return this.price;
	}
	
	public Run.Era getEra() {
		return this.era;
	}

	public BATIMENT getType() { return this.type; }

	public boolean isPurchased() {
		return isPurchased;
	}


	public Bonus[] purchase() {
		this.isPurchased = true;
		return this.bonuses;
	}
}
