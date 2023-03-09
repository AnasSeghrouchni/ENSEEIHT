package Visuals;

import java.awt.Color;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;

import Logic.Purchasable;

public class ShopItem extends JButton {

    /**
	 * 
	 */
	private static final long serialVersionUID = -7847926980174483996L;
	Purchasable theItem;
    Logic.Shop shop;

    public ShopItem(Logic.Shop shop, Purchasable p) {
        super();
        JLabel name = new JLabel(p.getName());
        JLabel price = new JLabel("Cost : " + p.getPrice() + "");
        this.theItem = p;
        this.shop = shop;
        this.setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
        this.addMouseListener(new MouseBuy(this.shop, this.theItem));
        this.add(name );
        this.add(price);
        this.setColor();
        this.setBonusInfos();
        this.add(Box.createHorizontalGlue());
    }
    
    public void setColor() {
        Color color = null;
        switch (theItem.getType()) {
            case HDV :
            color = Color.magenta;
            case UNIQUE :
              color = Color.white;
            case COMMUN :
             color = theItem.getBonus()[0].getBonusColor();
        };
        this.setBackground(color);
        this.setOpaque(true);
    }

    public void setBonusInfos() {
        for (Logic.Bonus bonus : theItem.getBonus()) {
            String label = "";
            if (bonus.getPercent() != 0) {
                label = label.concat("+ " + bonus.getPercent()* 100 + "% ");
            }
            if (bonus.getStatic() != 0) {
                label = label.concat("+ " + bonus.getStatic() + " ");
            }



            JLabel bonusInfo = new JLabel(label + bonus.getBonusStat().name());
            this.add(bonusInfo);
        }

    }

    private class MouseBuy extends MouseAdapter {

        Purchasable p;
        Logic.Shop shop;

        MouseBuy(Logic.Shop shop, Purchasable p) {
            this.p = p;
            this.shop = shop;
        }

        @Override
        public void mousePressed(MouseEvent e) {
            this.shop.startResearch(this.p);
            setEnabled(false);
        }

    }

}
