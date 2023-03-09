package Logic;

import static java.lang.Math.random;

public class Population {
	
	public long BASE_POPULATION = 1;
	
	public Population() {
		this.currentNormal = BASE_POPULATION;
	}

	private long currentNormal;
	private long currentWorkers;
	double foodNeed = 0;

	public void updatePopCount(float foodValue) {
		foodNeed = (this.currentNormal + this.currentWorkers) * 0.1;
		double ratio = (double) this.currentNormal / (double) (this.currentNormal + this.currentWorkers);
		double MINCHANCE = 0.2;
		double MAXCHANCE = 0.8;
		if (ratio < MINCHANCE) {
			ratio = MINCHANCE;
		} else if (ratio > MAXCHANCE) {
			ratio = MAXCHANCE;
		}
		if (Math.ceil((foodValue - foodNeed) * 0.1) > 0) {
			if (ratio > random()) {
				this.currentNormal = (long) (this.currentNormal + Math.ceil((foodValue - foodNeed) * 0.1));
			};
		}
	}



	/** Convertir n ouvriers
	 * 
	 * @param nbrWorkerToAdd le nombre d ouvrier à convertir
	 */
	public void addWorkers(long nbrWorkerToAdd) throws NotEnoughPopException {
		if (this.currentNormal <= nbrWorkerToAdd) {
			throw new NotEnoughPopException();
		} else {
			this.currentWorkers += nbrWorkerToAdd;
			this.currentNormal -= nbrWorkerToAdd;
		}
	}

	public long getCurrentPop() {
		return this.currentNormal + this.currentWorkers;
	}

	public long getCurrentNormal() {
		return this.currentNormal;
	}

	public long getCurrentWorkers() {
		return this.currentWorkers;
	}

	public double getCurrentFoodNeed() {return this.foodNeed; }

}
