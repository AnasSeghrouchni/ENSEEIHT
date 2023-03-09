package Visuals;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JProgressBar;

import Logic.Run;

public class RunTimer extends JProgressBar {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3446988872685006865L;
	int maxTicks;

	/**
	 * Constructeur de la classe.
	 * 
	 * @param run
	 */
	public RunTimer(Run run) {
		this.setBounds(0, 0, 200, 200);
		this.setStringPainted(true); // afficher le pourcentage
		this.setFont(new Font("Arial", Font.BOLD, 25));
		this.setBackground(Color.GREEN);
		this.setForeground(Color.WHITE);
		this.maxTicks = run.getTicksToLive();
		this.setValue(100);

	}

	public RunTimer() {
		this.setBounds(0, 0, 200, 200);
		this.setStringPainted(true); // afficher le pourcentage
		this.setFont(new Font("Arial", Font.BOLD, 20));
		this.setBackground(Color.GREEN);
		this.setForeground(Color.BLACK);
		// this.maxTicks = run.getTicksToLive();
		this.setValue(100);

	}

	public void update(Run run) {
		int timer = (int) (((float) run.getTicksToLive() / this.maxTicks) * 100);
		this.setValue(timer);
	}
}
