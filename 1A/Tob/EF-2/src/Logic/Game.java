package Logic;

import Visuals.MainWindow;

/**
 * Classe mère de l'application
 * 
 * @author nohehf
 *
 */
public class Game {

	public static final int TICK_SPEED = 117; // delai entre chaque tick en ms
	static int tick_count;

	public static Run run; // Run en cours
	static Boolean stop;

	public static Shop shop;

	private static MainWindow window;

	public Game() {
		
		/**
		 * A DEFINIR shop.fill();
		 */
		Game.window = new MainWindow();
	}

	private static void start() {
		shop = new Shop();
		run = new Run();
		stop = false;
		tick_count = 0;
	}

	// private void stop() {
	// 	stop = true;
	// }

	private static void tick() {
		tick_count += 1;
		//System.out.println("tick n°" + tick_count);
		run.tick();
		shop.tick();
		if (run.getTicksToLive() <= 0) {
			endRun();
		}

	}

	private static void endRun() {
		System.out.println("Run max ticks reached");
		shop = new Shop();
		run = new Run(run);
	}

	public static void main(String[] args) {

		start();

		Game.window = new MainWindow();

		// game loop
		while (!stop) {
			tick();
			Game.window.update();
			//System.out.println(run.getTicksToLive());
			try {
				Thread.sleep(TICK_SPEED);
			} catch (InterruptedException ex) {
				Thread.currentThread().interrupt();
			}
		}
	}

}
