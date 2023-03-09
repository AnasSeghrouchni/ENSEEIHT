
public class EnsembleChaine implements Ensemble{
	
	Cellule ensemble;

	/**
	 * Nombre d'éléments dans un ensemble.
	 * @return le cardinal.
	 */
	public int cardinal() {
		Cellule parcours=this.ensemble;
		int c=0;
		while (parcours!=null) {
			c++;
			parcours=parcours.suivant;
		}
		return c;
	}
	
	/**
	 * Savoir si un ensemble est Vide.
	 */
	public boolean estVide() {
		return (this.ensemble==null);
	}
	
	public boolean contient(int x) {
		Cellule c =this.ensemble;
		while(c!=null && c.entier!=x) {
			c=c.suivant;
		}
		return (c!=null);
	}
	
	public void ajouter(int x) {
		if (!(this.contient(x))) {
		this.ensemble= new Cellule(x,this.ensemble);
		}
	}
	
	public void supprimer(int x) {
	if(this.ensemble.entier==x) {
		Cellule Temp = this.ensemble.suivant;
		this.ensemble.suivant=null;
		this.ensemble=Temp;
		
	}
	Cellule current =this.ensemble;
	while(current.suivant.entier!=x) {
		current=current.suivant;
		if(current!=null) {
			Cellule temp=current.suivant.suivant;
			current.suivant.suivant=null;
			current.suivant=temp;
		}
		
	}
	
	}
	
}
