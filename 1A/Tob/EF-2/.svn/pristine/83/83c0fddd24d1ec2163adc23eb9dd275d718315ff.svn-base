package Logic.Tests;
import Logic.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import org.junit.Before;
import org.junit.Test;

public class PopulationTest {

    /* précision pour la comparaison entre réels. */
    public static final double EPSILON = 1e-6;

    //private Bonus bonusStatic, bonusPercent, bonusBoth;


    private Population population;

    @Before
    public void setup() {
        population = new Population();
    }


    @Test
    public void testerBaseValue() {
        assertEquals("Valeur de base incorrecte",1, population.getCurrentPop(), EPSILON);
        assertEquals("Valeur de base incorrecte",1, population.getCurrentNormal(), EPSILON);
        assertEquals("Valeur de base incorrecte",0, population.getCurrentWorkers(), EPSILON);
    }

    @Test
    public void testerAjout() {
        population.updatePopCount(100);
        assertEquals("Ajout de population raté",11, population.getCurrentPop(), EPSILON);
        assertEquals("Ajout de population raté",11, population.getCurrentNormal(), EPSILON);
        assertEquals("Ajout de population raté",0, population.getCurrentWorkers(), EPSILON);
    }


    @Test
    public void testerAjoutWorker() {
        population.updatePopCount(100);
        try {
            population.addWorkers(1);
        } catch (NotEnoughPopException e) {
            fail("Ajout d'un ouvrier raté");
        }
        assertEquals("Ajout d'un ouvrier raté",11, population.getCurrentPop(), EPSILON);
        assertEquals("Ajout d'un ouvrier raté",10, population.getCurrentNormal(), EPSILON);
        assertEquals("Ajout d'un ouvrier raté",1, population.getCurrentWorkers(), EPSILON);
    }

    @Test
    public void testerAjoutTropWorker() {
        population.updatePopCount(100);
        try {
            population.addWorkers(11);
            fail("Pas d'exception levée");
        } catch (NotEnoughPopException ignored) {

        }
    }
}