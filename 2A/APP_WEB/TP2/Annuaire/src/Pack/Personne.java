package Pack;

import java.util.ArrayList;


public class Personne {
	private String prenom;
	private String nom;
	private int id;
	private ArrayList<Adresse> adresses;
	
	public Personne(String p, String n, int i) {
		this.prenom = p;
		this.nom = n;
		this.id = i;
		this.adresses= new ArrayList<Adresse>();
	}
	
	public void ajouterAdd(Adresse a) {
		this.adresses.add(a);
	}
	
	public void setPrenom(String s) {
		this.prenom = s;
	}
	
	public String getPrenom() {
		return this.prenom;
	}
	
	public String getNom() {
		return this.nom;
	}


}
