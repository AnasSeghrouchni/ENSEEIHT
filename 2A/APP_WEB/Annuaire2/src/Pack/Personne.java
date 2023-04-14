package Pack;

import java.util.Collection;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

@Entity
public class Personne {
	private String prenom;
	private String nom;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	//@OneToMany(mappedBy="proprietaire", fetch=FetchType.EAGER)
	//private Collection<Adresse> adresses;
	@ManyToMany(fetch=FetchType.EAGER)
	private Collection<Adresse> adresses;

	public Personne() {
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

	public Collection<Adresse> getAdresses() {
		return adresses;
	}

	public void setAdresses(Collection<Adresse> adresses) {
		this.adresses = adresses;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public void setId(int id) {
		this.id = id;
	}

}