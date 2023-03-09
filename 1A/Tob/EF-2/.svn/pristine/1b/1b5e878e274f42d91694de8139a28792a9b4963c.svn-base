package Visuals;

import javax.swing.BoxLayout;
import javax.swing.JPanel;

public class Market extends JPanel {

    /**
	 * 
	 */
	private static final long serialVersionUID = -690067855921763784L;
	Inventory inventory;
    Visuals.Shop shop;
    Research research;
    
    public Market(Logic.Shop shop) {
        this.setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        this.inventory = new Inventory(shop);
        this.shop = new Shop(shop);
        this.research = new Research(shop);
        JPanel lists = new JPanel(new java.awt.FlowLayout());
        lists.add(this.shop);
        lists.add(this.inventory);
        this.add(this.research);
        this.add(lists);
    }

    public void update() {
        this.inventory.update();
        this.shop.update();
        this.research.update();
    }
}
