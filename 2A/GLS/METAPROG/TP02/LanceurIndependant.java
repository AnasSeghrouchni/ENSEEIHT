import java.lang.reflect.*;
import java.util.*;

/** L'objectif est de faire un lanceur simple sans utiliser toutes les clases
  * de notre architecture JUnit.   Il permet juste de valider la compréhension
  * de l'introspection en Java.
  */
public class LanceurIndependant {
	private int nbTestsLances;
	private int nbErreurs;
	private int nbEchecs;
	private List<Throwable> erreurs = new ArrayList<>();

	public LanceurIndependant(String... nomsClasses) {
	    System.out.println();

		// Lancer les tests pour chaque classe
		for (String nom : nomsClasses) {
			try {
				System.out.print(nom + " : ");
				this.testerUneClasse(nom);
				System.out.println();
			} catch (ClassNotFoundException e) {
				System.out.println(" Classe inconnue !");
			} catch (Exception e) {
				System.out.println(" Problème : " + e);
				e.printStackTrace();
			}
		}

		// Afficher les erreurs
		for (Throwable e : erreurs) {
			System.out.println();
			e.printStackTrace();
		}

		// Afficher un bilan
		System.out.println();
		System.out.printf("%d tests lancés dont %d échecs et %d erreurs.\n",
				nbTestsLances, nbEchecs, nbErreurs);
	}


	public int getNbTests() {
		return this.nbTestsLances;
	}


	public int getNbErreurs() {
		return this.nbErreurs;
	}


	public int getNbEchecs() {
		return this.nbEchecs;
	}


	private void testerUneClasse(String nomClasse)
		throws ClassNotFoundException, InstantiationException,
						  IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException
	{
		// Récupérer la classe
		Class classe = Class.forName(nomClasse);
		// Récupérer les méthodes "preparer" et "nettoyer"
		Method preparer;
		Method nettoyer;
		try {
			preparer = classe.getMethod("preparer");
		}
		catch(NoSuchMethodException e) {
			preparer = null;
		}
		try {
			nettoyer = classe.getMethod("nettoyer");
		}
		catch(NoSuchMethodException e) {
			 nettoyer = null;
		}
		// Instancier l'objet qui sera le récepteur des tests
		Object objet = classe.getConstructor().newInstance();

		// Exécuter les méthods de test
		Method[] test = classe.getMethods();
		for (Method test1 : test) {
			
			if (preparer != null) {
				  preparer.invoke(objet);
			}
			if (test1.getName().startsWith("test")) {
				try {
					test1.invoke(objet); 
					this.nbTestsLances++;
				} catch (AssertionError e) {
					this.nbEchecs++;
					this.nbTestsLances++;
					e.getMessage();
				} catch (Exception e) {
					this.nbErreurs++;
					this.nbTestsLances++;
					e.getMessage();
				} 
			}
			if (nettoyer != null) {
			  nettoyer.invoke(objet);
			}
		  }
		}

	public static void main(String... args) {
		LanceurIndependant lanceur = new LanceurIndependant(args);
	}

}
