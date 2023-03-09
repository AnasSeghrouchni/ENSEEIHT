package Visuals;

import javax.swing.JFrame;

import Logic.Game;

public class MainWindow extends JFrame {

    /**
	 * 
	 */
	private static final long serialVersionUID = 411612413079832671L;
	// shop menu
    Market gameMarket;
    // the actual game where you can click and see the score
    PlayGround gamePlayGround;

    public MainWindow() {
        super("civ++");
        java.awt.Container content = this.getContentPane();
        content.setLayout(new java.awt.FlowLayout());
        this.setLocation(0, 0);
        this.gameMarket = new Market(Game.shop);
        this.gamePlayGround = new PlayGround("src/Sprites/", "./Sprites/");
        content.add(gamePlayGround);
        content.add(gameMarket);

        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.pack();
        this.setVisible(true);
    }

    public void update() {
        // this.gameShop.update();
        this.gamePlayGround.update("./Sprites/", "src/Sprtes/");
        this.gameMarket.update();
        
        
    }

}
