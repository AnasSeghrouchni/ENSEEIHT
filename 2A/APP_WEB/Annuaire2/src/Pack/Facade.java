package Pack;

import java.util.ArrayList;
import java.util.Collection;

import javax.ejb.Singleton;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Singleton
public class Facade {
	
	@PersistenceContext
	EntityManager em;
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne p = new Personne();
		p.setNom(nom);
		p.setPrenom(prenom);
		p.setAdresses(new ArrayList<Adresse>());
		em.persist(p);
		System.out.println("Ajout de "+ nom + prenom);
		
	};
	public void ajoutAdresse(String rue, String ville) {
		Adresse a = new Adresse();
		a.setRue(rue);
		a.setVille(ville);
		a.setProprietaires(new ArrayList<Personne>());
		em.persist(a);
		
		
	};
	public Collection<Personne> listePersonnes(){
		TypedQuery<Personne> req = em.createQuery("select p from Personne p", Personne.class) ;
		Collection<Personne> lp = req.getResultList();
		return lp;
		
	};
	public Collection<Adresse> listeAdresses(){
		TypedQuery<Adresse> req = em.createQuery("select a from Adresse a", Adresse.class) ;
		Collection<Adresse> la = req.getResultList();
		return la;	};
		
	public void associer(int personneId, int adresseId) {
		Personne p = em.find(Personne.class, personneId);
		Adresse a = em.find(Adresse.class, adresseId);
		//a.setProprietaire(p);
		p.ajouterAdd(a);
	};
}
