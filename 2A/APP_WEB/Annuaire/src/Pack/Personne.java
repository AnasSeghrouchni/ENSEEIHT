package Pack;

import java.util.*;


public class Personne {
	private String prenom;
	private String nom;
	private int id;
	private Collection<Adresse> adresses;
	
	public Personne(String p, String n, int i) {
		this.prenom = p;
		this.nom = n;
		this.id = i;
		this.adresses = new ArrayList<Adresse>();
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
	
	public int getId() {
		return id;
	}
	
	public Collection<Adresse> getAdd(){
		return adresses;
	}

}