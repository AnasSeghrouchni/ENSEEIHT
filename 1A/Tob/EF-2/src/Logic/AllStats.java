package Logic;

public class AllStats {


	/* Stat de bonheur */
	private final Happiness happiness;
	
	/* Classe de population */
	private final Population population;
	
	/* Stat de production */
	private final Production production;
	
	/* Stat de nourriture */
	private final Food food;
	
	/* Stat d'habitation */
	private final Housing housing;
	
	/* Vitesse de construction */
	private double FinalProduction;

	
	public AllStats() {
		happiness = new Happiness();
		population = new Population();
		production = new Production();
		food = new Food();
		housing = new Housing();
		FinalProduction = production.getCurrentValue();
	}

	public void printValues() {
		System.out.print("Pop : " + population.getCurrentPop());
		System.out.print(", Food : " + food.getCurrentValue());
		System.out.print(", Production : " + production.getCurrentValue());
		System.out.print(", Happiness : " + happiness.getCurrentValue());
		System.out.print(", Housing : " + housing.getCurrentValue() + "\n");
	}

	/* Update toutes les statistiques en appelant toutees les fonctions respectives necessaires. */
	public void updateStats() {
		food.appliquerBonus();
		population.updatePopCount(food.getCurrentValue());
		housing.appliquerBonus(population.getCurrentPop());
		production.appliquerBonus();
		FinalProduction = production.getCurrentValue() * (1 + population.getCurrentWorkers() * 0.1);
		happiness.appliquerBonus(housing.currentValue);
		printValues();
	}
	/** Convertir n ouvriers
	 * @param nbrWorkerToAdd le nombre d ouvrier à convertir
	 */
	public void addWorker(long nbrWorkerToAdd) throws NotEnoughPopException{
		population.addWorkers(nbrWorkerToAdd);
	}

	/** Retourne un tableau avec toutes les stats constantes, sans prendre en compte la consommation des habitants, en format long.
	 * @return resultLong Le tableau de stat dans l'ordre suivant : pop. totale, pop. normale, nourriture, habitations totales, production
	 */
	public long[] getAllRawLong() {
		return new long[]{ population.getCurrentNormal(), population.getCurrentPop(), (long) food.getCurrentValue(),(long) housing.getTotalValue(), (long) production.getCurrentValue()};
	}
	
	/** Retourne un tableau avec toutes les stats, en format long.
	 * @return resultLong Le tableau de stat dans l'ordre suivant : pop. ouvriers, bonheur, nourriture restante, habitations restantes, production finale
	 */
	public long[] getAllLong() {
		return new long[]{population.getCurrentWorkers(),(long) happiness.getCurrentValue(),(long) food.getCurrentValue() - (long) population.getCurrentFoodNeed(),(long) housing.getCurrentValue(),(long) FinalProduction};
	}



	/** Avoir la production finale
	 * @return finalProduction la production finale
	 */
	public double getCurrentProduction() {
		return FinalProduction;
	}
	
	/** Appliquer un bonus, la méthode s'occupe d'augmenter la bonne statistique.
	 * @param bonus Le bonus à appliquer
	 */
	public void applyBonus(Bonus bonus) {
		switch (bonus.getBonusStat()) {
			case FOOD :
				food.addBonus(bonus);
			case HOUSING :
				housing.addBonus(bonus);
			case HAPPINESS :
				happiness.addBonus(bonus);
			case PRODUCTION :
				production.addBonus(bonus);
		}
	}

	/** Appliquer plusieurs bonus d'un coup, la méthode s'occupe d'augmenter la bonne statistique pour chacun d entre eux.
	 * @param bonuses Les bonuses à appliquer
	 */
	public void applyBonus(Bonus[] bonuses) {
		for (Bonus bonus : bonuses) {
			applyBonus(bonus);
		}
	}
}