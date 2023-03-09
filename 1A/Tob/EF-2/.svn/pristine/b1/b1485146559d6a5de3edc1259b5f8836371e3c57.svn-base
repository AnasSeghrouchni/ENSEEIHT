package Logic.Tests;
import Logic.*;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class HappinessTest {

    /* précision pour la comparaison entre réels. */
    public static final double EPSILON = 1e-6;

    private Bonus bonusStatic, bonusPercent, bonusBoth, bonusLot;


    private Happiness happiness;

    @Before
    public void setup() {
        bonusStatic = new Bonus(Bonus.BonusStat.HAPPINESS,15);
        bonusPercent = new Bonus(Bonus.BonusStat.HAPPINESS,(float) 0.1);
        bonusBoth = new Bonus(Bonus.BonusStat.HAPPINESS,10,(float) 0.1);
        happiness = new Happiness();
        bonusLot = new Bonus(Bonus.BonusStat.HAPPINESS,60);
    }


    @Test
    public void testerBaseValue() {
        assertEquals("Valeur de base incorrecte",50, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerStatique() {
        happiness.addBonus(bonusStatic);
        happiness.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus statique",65, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerPercent() {
        happiness.addBonus(bonusPercent);
        happiness.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus dynamique",55, happiness.getCurrentValue(), EPSILON);
    }
    @Test
    public void testerBoth() {
        happiness.addBonus(bonusBoth);
        happiness.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus dynamique",66, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerBadHousing() {
        happiness.appliquerBonus(-10);
        assertEquals("Mauvaise application du Housing ratio",40, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerGoodHousing() {
        happiness.appliquerBonus(10);
        assertEquals("Mauvaise application du Housing ratio",50, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void  testerTropContent() {
        happiness.addBonus(bonusLot);
        happiness.appliquerBonus(0);
        assertEquals("Valeur trop élevée",100, happiness.getCurrentValue(), EPSILON);
    }

    @Test
    public void  testerPasContent() {
        happiness.appliquerBonus(-100);
        assertEquals("Valeur trop faible",0, happiness.getCurrentValue(), EPSILON);
    }
}