package Visuals;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JProgressBar;

public class ProgressBar extends JProgressBar {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8626275217557551927L;
	int max;

	/**
	 * Constructeur de la classe.
	 *
	 * @param max
	 */
	public ProgressBar(int max, int width, int height) {
		this.setBounds(0, 0, width, height);
		this.setStringPainted(true); // afficher le pourcentage
		this.setFont(new Font("Arial", Font.BOLD, 25));
		this.setBackground(Color.GREEN);
		this.setForeground(Color.WHITE);
		this.max = max;
		this.setValue(100);
	}

	public void update(int current) {
		int timer = (int) (((float) current / this.max) * 100);
		this.setValue(timer);
	}
}
