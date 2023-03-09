// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;
import java.lang.Thread;


public class PhiloSemAsymetrique implements StrategiePhilo {
	
	private Semaphore[] fourchettes ;
	private int n;
    /****************************************************************/

    public PhiloSemAsymetrique (int nbPhilosophes) {
    	this.fourchettes = new Semaphore[nbPhilosophes];
    	this.n = nbPhilosophes;
    	for ( int i=0; i<nbPhilosophes; i++ ) {
    		this.fourchettes[i] = new Semaphore(1);
    	}
    	
    }
    

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
    	if (no == 0) {
    	fourchettes[(no+1) % this.n].acquire();
    	Thread.sleep(10000);

    	fourchettes[no % this.n].acquire();
    	}
    	else {
    		fourchettes[(no) % this.n].acquire();
        	Thread.sleep(10000);

    		fourchettes[(no+1) % this.n].acquire();
    	}
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no)
    {
    	fourchettes[(no+1) % this.n].release();
    	fourchettes[no % this.n].release();
    	
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie asymetrique";
    }

}

