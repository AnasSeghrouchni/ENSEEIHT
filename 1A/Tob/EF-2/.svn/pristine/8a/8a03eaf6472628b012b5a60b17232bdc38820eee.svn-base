package Visuals;

import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

import Logic.Purchasable;

public class Shop extends JScrollPane {

    /**
	 * 
	 */
	private static final long serialVersionUID = -1262791520274522762L;
	Logic.Shop shop;
    ArrayList<Purchasable> items;
    JPanel view;

    public Shop(Logic.Shop shop) {
        super(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        this.setMaximumSize(new Dimension(200, 500));
        this.setPreferredSize(new Dimension(200, 500));

        this.view = createView(shop);
        this.setViewportView(view);

        this.shop = shop;
        this.items = new ArrayList<Purchasable>(shop.getPurchasableItems());
    }

    public static JPanel createView(Logic.Shop shop) {
        JPanel view = new JPanel();
        view.setLayout(new javax.swing.BoxLayout(view, javax.swing.BoxLayout.Y_AXIS));
        ShopItem item;

        for (Purchasable purchasable : shop.getPurchasableItems()) {
            item = new ShopItem(shop, purchasable);
            view.add(item);
        }

        return view;
    }

    public void update() {
        ShopItem item;
        if (!this.items.equals(shop.getPurchasableItems())) {
            this.items = new ArrayList<>(shop.getPurchasableItems());
            view.removeAll();
            for (Purchasable purchasable : this.items) {
                item = new ShopItem(shop, purchasable);
                view.add(item);
            }
            view.revalidate();
            view.repaint();
        }
        // for (Purchasable purchasable : shop.getPurchasableItems()) {
        // if (!this.items.contains(purchasable)) {
        // item = new ShopItem(shop, purchasable);
        // this.items.add(purchasable);
        // view.add(item);
        // }
        // }
    }

}
