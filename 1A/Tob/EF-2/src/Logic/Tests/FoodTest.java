package Logic.Tests;
import Logic.*;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

public class FoodTest {

    /* précision pour la comparaison entre réels. */
    public static final double EPSILON = 1e-6;

    private Bonus bonusStatic, bonusPercent, bonusBoth;


    private Food food;

    @Before
    public void setup() {
        bonusStatic = new Bonus(Bonus.BonusStat.FOOD,15);
        bonusPercent = new Bonus(Bonus.BonusStat.FOOD,(float) 0.1);
        bonusBoth = new Bonus(Bonus.BonusStat.FOOD,10,(float) 0.1);
        food = new Food();
    }


    @Test
    public void testerBaseValue() {
        assertEquals("Valeur de base incorrecte",10, food.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerStatique() {
        food.addBonus(bonusStatic);
        food.appliquerBonus();
        assertEquals("Mauvaise application de bonus statique",25, food.getCurrentValue(), EPSILON);
    }

    @Test
    public void testerPercent() {
        food.addBonus(bonusPercent);
        food.appliquerBonus();
        assertEquals("Mauvaise application de bonus dynamique",11, food.getCurrentValue(), EPSILON);
    }
    @Test
    public void testerBoth() {
        food.addBonus(bonusBoth);
        food.appliquerBonus();
        assertEquals("Mauvaise application de bonus dynamique",22, food.getCurrentValue(), EPSILON);
    }
}