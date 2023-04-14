package Pack;

import java.util.Collection;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

@Entity
public class Adresse {
	private String rue;
	private String ville;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	//@ManyToOne
	//private Personne proprietaire;
	@ManyToMany(mappedBy="adresses",fetch=FetchType.EAGER)
	private Collection<Personne> proprietaires;
	
	public Adresse() {
	}
	
	public String getRue() {
		return this.rue;
	}	
	
	public String getVille() {
		return this.ville;
	}
	
	public void setRue(String r) {
		this.rue = r;
	}
	
	public void setVille(String r) {
		this.ville = r;
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	//public void setProprietaire(Personne p) {
	//	this.proprietaire  p;
	//}
	
	public void setProprietaires(Collection<Personne> lp) {
		this.proprietaires = lp;
	}
	
	public void ajouterPer(Personne p) {
		this.proprietaires.add(p);
	}

}
