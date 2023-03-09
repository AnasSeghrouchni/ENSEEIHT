package Visuals;

import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;

import Logic.Game;

public class PlayGround extends JPanel {

    /**
	 * 
	 */
	private static final long serialVersionUID = -6951727068295512157L;
	ProgressBar gameTimer; // le timer de la run au cas ou
    Score gameScore;
    RawScore rawGameScore;
    Island gameIsland;

    public PlayGround(String path2sprites, String pathFallback) {
        super();
        this.gameTimer = new ProgressBar(Game.run.getTicksToLive(), 200, 200);
        this.gameScore = new Score(Score.createModel(Game.run.getAllStats().getAllLong()));
        this.rawGameScore = new RawScore(Score.createModel(Game.run.getAllStats().getAllRawLong()));
        this.gameIsland = new Island(path2sprites, pathFallback);
        gameIsland.setAlignmentX(JLabel.CENTER_ALIGNMENT);
        gameIsland.setAlignmentY(JLabel.CENTER_ALIGNMENT);

        this.setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));

        this.add(rawGameScore);
        this.add(gameScore);
        this.add(gameIsland);
        this.add(gameTimer);
    }

    public void update(String path2sprites, String pathfallback) {
        gameScore.setScore(Game.run.getAllStats().getAllLong());
        rawGameScore.setScore(Game.run.getAllStats().getAllRawLong());
        gameTimer.update(Game.run.getTicksToLive());
        gameIsland.update(Game.run.getPurchased(), path2sprites,pathfallback,Game.run.getEra());
    }
}
