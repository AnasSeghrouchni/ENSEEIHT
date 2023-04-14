package Pack;

import java.util.*;
import java.util.HashMap;

import javax.ejb.Singleton;

@Singleton
public class Facade {
	
	private HashMap<Integer, Personne> Personnes = new HashMap<Integer, Personne>();
	private HashMap<Integer, Adresse> Adresses = new HashMap<Integer, Adresse>();
	private int idP = 0;
	private int idA = 0;
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne p = new Personne(nom,prenom,idP);
		Personnes.put(idP,p);
		this.idP++;
		System.out.println("Ajout de "+ nom + prenom);
		
	};
	public void ajoutAdresse(String rue, String ville) {
		Adresse a = new Adresse(rue,ville,idA);
		Adresses.put(idA, a);
		idA++;
		
	};
	public Collection<Personne> listePersonnes(){
		return Personnes.values();
		
	};
	public Collection<Adresse> listeAdresses(){
		return Adresses.values();
	};
		
	public void associer(int personneId, int adresseId) {
		Personne p = Personnes.get(personneId);
		p.ajouterAdd(Adresses.get(adresseId));
	};
}
