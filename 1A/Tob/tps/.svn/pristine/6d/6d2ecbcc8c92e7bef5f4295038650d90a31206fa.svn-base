import org.junit.*;

import allumettes.Before;
import allumettes.JeuReel;
import allumettes.StratNaive;
import allumettes.Strategie;
import allumettes.Test;

import static org.junit.Assert.*;

public class ObjetNommeTest {
	
	private Strategie strat;
	
	@Before public void setUp() {
		this.strat= new StratNaive();
	}
	
	@Test public void testGetPrise()
	    {
	        assertEquals(this.strat.getPrise(new JeuReel(13)), 3);
	        assertEquals(this.strat.getPrise(new JeuReel(5)), 3 );
	        assertEquals(this.strat.getPrise(new JeuReel(3)), 2);
	        assertEquals(this.strat.getPrise(new JeuReel(1)), 2);
	              
	    }
	}

}
