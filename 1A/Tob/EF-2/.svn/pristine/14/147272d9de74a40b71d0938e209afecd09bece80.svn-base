package Logic;

import java.util.ArrayList;
import java.util.Objects;

/**
 * une partie
 * 
 * @author nohehf
 *
 */

public class Run {

	private Era era;
	int ticksToLive = 300; // durée de vie d'une run
	public static AllStats stats;

	private ArrayList<Purchasable> purchased = new ArrayList<Purchasable>();

	public enum Era {
		ANTIQUITY, MIDDLEAGE,INDUSTRIAL,NUMERIC {
			@Override
			public Era next() {
				return null; // see below for options for this line
			};
		};

		public Era next() {
			// No bounds checking required here, because the last instance overrides
			return values()[ordinal() + 1];
		}
	}

	// Démarrer la première run
	public Run() {
		System.out.println("Starting first run");
		this.era = Era.ANTIQUITY;
		stats = new AllStats();
	}

	// Démarer une run à la fin d'une autre run
	public Run(Run previousRun) {
		System.out.println("Starting another run");
		this.era = Era.ANTIQUITY;
		stats = new AllStats();

		// on ré-ajoute toutes les upgrades permanentes à la nouvelle run
		for (Purchasable p: previousRun.purchased) {
			if(p.getType() == Purchasable.BATIMENT.UNIQUE) {
				this.addPurchase(p);
			}
		}
	}

	public void tick() {
		this.ticksToLive -= 1;
		stats.updateStats();
	}

	// GETTERS:

	public Era getEra() {
		return this.era;
	}

	public int getTicksToLive() {
		return this.ticksToLive;
	}

	public AllStats getAllStats() {
		return stats;
	}

	public ArrayList<Purchasable> getPurchased() {
		return this.purchased;
	}

	// SETTERS:
	public void addPurchase(Purchasable purchasable) {
		Bonus[] bonuses = purchasable.purchase();
		stats.applyBonus(bonuses);
		this.purchased.add(purchasable);
		if (purchasable.getType() == Purchasable.BATIMENT.HDV && !Objects.equals(purchasable.getName(), "Tipi")) {
			era = purchasable.getEra().next();
		}
	}
}
