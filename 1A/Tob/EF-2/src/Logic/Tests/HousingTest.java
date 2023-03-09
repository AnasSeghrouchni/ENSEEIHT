package Logic.Tests;
import Logic.*;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

public class HousingTest {

    /* précision pour la comparaison entre réels. */
    public static final double EPSILON = 1e-6;

    private Bonus bonusStatic, bonusPercent, bonusBoth;


    private Housing housing;

    @Before
    public void setup() {
        bonusStatic = new Bonus(Bonus.BonusStat.HOUSING,15);
        bonusPercent = new Bonus(Bonus.BonusStat.HOUSING,(float) 0.1);
        bonusBoth = new Bonus(Bonus.BonusStat.HOUSING,10,(float) 0.1);
        housing = new Housing();
    }


    @Test
    public void testerBaseValue() {
        assertEquals("Valeur de base incorrecte",10, housing.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerStatique() {
        housing.addBonus(bonusStatic);
        housing.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus statique",25, housing.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerPercent() {
        housing.addBonus(bonusPercent);
        housing.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus dynamique",11, housing.getCurrentValue(), EPSILON);
    }
    @Test
    public void testerBoth() {
        housing.addBonus(bonusBoth);
        housing.appliquerBonus(0);
        assertEquals("Mauvaise application de bonus dynamique",22, housing.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerHabitants() {
        housing.appliquerBonus(100);
        assertEquals("Mauvaise application de la PopSize",9, housing.getCurrentValue(), EPSILON);
    }
}