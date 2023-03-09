package Visuals;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JProgressBar;

public class Frame extends JFrame {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6680924199336010672L;
	private Frame frame;

	public Frame getFram() {
		return this.frame;
	}

	Frame() {
		//set
		super();
		java.awt.Container content = this.getContentPane();

		//Island
		JLabel i = new Island("../Sprites/","./Sprites");

		//progress Bar
		JProgressBar j = new RunTimer();

		//Score
		long[] long_tableau = {50,1,50,1,10,10};
		JList<String> k = new Score(Score.createModel(long_tableau));

		//container
		content.setLayout(new BorderLayout());
		content.add(j, BorderLayout.SOUTH);
		content.add(i, BorderLayout.CENTER);
		content.add(k, BorderLayout.NORTH);



		//set
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setSize(500, 500);
		this.pack();
		this.setLocationRelativeTo(null);
		this.setVisible(true);
	}

}
