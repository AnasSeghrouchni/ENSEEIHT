package Visuals;

import java.awt.Dimension;

import javax.swing.JPanel;

import Logic.Purchasable;

public class Research extends JPanel {

    /**
	 * 
	 */
	private static final long serialVersionUID = 9172991426166470443L;
	Logic.Shop shop;
    Purchasable item;
    ProgressBar progressBar;

    public Research(Logic.Shop shop) {
        this.setMaximumSize(new Dimension(200, 100));
        this.setPreferredSize(new Dimension(200, 100));

        this.shop = shop;
        this.item = null;

        this.progressBar = new ProgressBar(0, 100, 100);
        this.progressBar.update(0);
        this.resetView();
    }

    public void resetView() {
        this.setLayout(new javax.swing.BoxLayout(this, javax.swing.BoxLayout.Y_AXIS));
        this.add(progressBar);
    }

    public void update() {
        if(!(this.item == shop.getResearched())) {
            this.removeAll();
            this.item = shop.getResearched();
            if(this.item != null) {
                ShopItem shopItem = new ShopItem(shop, item);
                this.add(shopItem);
                this.progressBar = new ProgressBar(item.getPrice(), 100 ,100);
                this.resetView();
            } else {
                this.progressBar = new ProgressBar(0, 100, 100);
                this.progressBar.update(0);
                this.resetView();
            }
        }
        if(item != null) {
            this.progressBar.update(shop.getResearchTicksLeft());
        }
    }

}
