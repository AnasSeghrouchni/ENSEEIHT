package Visuals;

import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

import Logic.Purchasable;

public class Inventory extends JScrollPane {

    /**
	 * 
	 */
	private static final long serialVersionUID = -835587868851037358L;
	Logic.Shop shop;
    ArrayList<Purchasable> items;
    JPanel view;

    public Inventory(Logic.Shop shop) {
        super(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        this.setMaximumSize(new Dimension(200, 500));
        this.setPreferredSize(new Dimension(200, 500));

        this.view = createView(shop);
        this.setViewportView(view);

        this.shop = shop;
        this.items = new ArrayList<Purchasable>();
    }

    public static JPanel createView(Logic.Shop shop) {
        JPanel view = new JPanel();
        view.setLayout(new javax.swing.BoxLayout(view, javax.swing.BoxLayout.Y_AXIS));
        ShopItem item;

        for (Purchasable purchasable : shop.getPurchasedItems()) {
            item = new ShopItem(shop, purchasable);
            view.add(item);
        }

        return view;
    }

    public void update() {
        ShopItem item;
        if(!this.items.equals(shop.getPurchasedItems())) {
            this.items = new ArrayList<>(shop.getPurchasedItems());
            view.removeAll();
            for (Purchasable purchasable : this.items) {
                item = new ShopItem(shop, purchasable);
                item.setEnabled(false);
                view.add(item);
                this.revalidate();
                this.repaint();
            }
        }

//        for (Purchasable purchasable : shop.getPurchasableItems()) {
//            if (!this.items.contains(purchasable)) {
//                item = new ShopItem(shop, purchasable);
//                this.items.add(purchasable);
//                view.add(item);
//            }
//        }
    }

}
