package Visuals;


import javax.swing.JLabel;

import Logic.AllStats;
import Logic.Game;
import Logic.NotEnoughPopException;


import java.util.ArrayList;



import Logic.Purchasable;
import Logic.Purchasable.BATIMENT;
import Logic.Run.Era;

import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;

public class Island extends JLabel implements MouseListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7097275527211703878L;
	AllStats stats;
	/**
	 * île afficher avec batiments et hotel de ville
	 */
	BufferedImage island;
	/**
	 * île avec uniquement les batiments sans l'hotel de ville
	 */
	BufferedImage island_bat;
	private static final int ISLAND_HEIGHT = 600, ISLAND_WIDTH = 600;
	ArrayList<Purchasable> items;
	static String path2string;
	static String pathFallBack;

	public Island(String path2sprites, String pathFallback) {
		// ajouter run et allstats
		// this.stats = all;
		Island.path2string = path2sprites;
		Island.pathFallBack = pathFallback;
		try {
			this.island = resize(ImageIO.read(new File(path2sprites + "ile.png")), ISLAND_WIDTH, ISLAND_HEIGHT);
		} catch (IOException e) {
			try {
				this.island = resize(ImageIO.read(new File(pathFallback + "ile.png")), ISLAND_WIDTH, ISLAND_HEIGHT);
			} catch (IOException e2) {
				System.out.println("File Error");
			}

		}
		this.setIcon(new ImageIcon(island));
		this.island_bat = copie(this.island);
		this.items = new ArrayList<Purchasable>();
		this.addMouseListener(this);
	}

	/**
	 * Ajoute une image2 sur une image1 à une position x et y (pixel)
	 * @param image1 la première image
	 * @param image2 la seconde image
	 * @param x	la position x en pixel
	 * @param y la position y en pixel
	 * @return l'image1 modifiée
	 */
	public static BufferedImage addImage(BufferedImage image1, BufferedImage image2, int x, int y){ 
		Graphics2D g2d = image1.createGraphics(); 
		g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, 
						RenderingHints.VALUE_ANTIALIAS_ON); 
		g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, 
						RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY); 
	  
		g2d.drawImage(image2, x, y, null); 
	  
		g2d.dispose(); 
	  
		return image1 ; 
	}
	/**
	 * Pour resize une BuffredImage 
	 * @param img L'image à modifier
	 * @param newW Nouvelle largeur
	 * @param newH Nouvelle Hauteur
	 * @return L'image resize
	 */
	public static BufferedImage resize(BufferedImage img, int newW, int newH) { 
		Image tmp = img.getScaledInstance(newW, newH, Image.SCALE_SMOOTH);
		BufferedImage dimg = new BufferedImage(newW, newH, BufferedImage.TYPE_INT_ARGB);
	
		Graphics2D g2d = dimg.createGraphics();
		g2d.drawImage(tmp, 0, 0, null);
		g2d.dispose();
	
		return dimg;
	}  
	
	/**
	 * Permet de copier une bufferedImage sans dépendance
	 * @param image l'image à copier
	 * @return une copie de l'image
	 */
	static BufferedImage copie(BufferedImage image) { 
		ColorModel cm = image.getColorModel(); 
		boolean isAlphaPremultiplied = cm.isAlphaPremultiplied(); 
		WritableRaster raster = image.copyData(null); 
		return new BufferedImage(cm, raster, isAlphaPremultiplied, null); 
	}

	/**
	 * Ajout d'un worker à chauqe clique et affiche un "+1" si l'action a reussi
	 * et une croix rouge sinon à l'endroit où le joueur à cliqué
	 * 
	 */
	@Override
	public void mousePressed(MouseEvent arg0) {
		BufferedImage icone = null;
		String nom_icone = "";
		try{
		Game.run.getAllStats().addWorker(1);
		nom_icone ="plus1.png";
		}	
		catch (NotEnoughPopException e) {
			System.out.println("Pas assez de Worker");
			nom_icone = "croix.png";
		}
		
		try {
			 icone = ImageIO.read(new File(Island.path2string + nom_icone ));
		}
		catch (IOException e){
			try{
			icone = ImageIO.read(new File(Island.pathFallBack + nom_icone ));
			}
			catch(IOException er){
				System.out.println("File Error : " +nom_icone);
			}
		}

			BufferedImage copieisland = copie(this.island);
			icone = resize(icone, 50, 50);
			copieisland =  addImage(copieisland, icone,arg0.getX()-25, arg0.getY()-30);
			this.setIcon(new ImageIcon(copieisland));
		}
	
		

	@Override
	public void mouseReleased(MouseEvent arg0) {
	}

	@Override
	public void mouseClicked(MouseEvent arg0) {
	}

	@Override
	public void mouseEntered(MouseEvent arg0) {
	}

	@Override
	public void mouseExited(MouseEvent arg0) {
	}
	
	/**
	 * Ajoute un batiment sur l'image de l'île en le redimensionnant
	 * @param nom_image nom du batiment à ajouter avec le .png
	 * @param x la position x sur l'île du batiment à ajouter
	 * @param y la position y sur l'île du batiment à ajouter
	 * @param newW nouvelle largeur du batiment
	 * @param newH nouvelle longeur du batiment
	 * @param hdv boolean permettant de savoir si le batiment à ajouter est un hotel de ville (afin d'enlever l'ancien)
	 */
	private void afficher_bat(String nom_image ,int x, int y, int newW, int newH, Boolean hdv){

		BufferedImage building = null;
		try {
			building = ImageIO.read(new File(Island.path2string + nom_image));
		} catch (IOException e) {
			try {
				building = ImageIO.read(new File(Island.pathFallBack + nom_image));
			} catch (IOException e1) {
				System.out.println("File Error :" + nom_image);	
			}
			}
			building = resize(building, newW, newH);
			if (hdv){
				this.island = copie(this.island_bat);
			}
			else{
				this.island_bat = addImage(this.island_bat, building, x, y);
			}
			this.island =  addImage(this.island, building,x, y);
			
			this.setIcon(new ImageIcon(this.island));
		}
	
		/**
		 * Fais une mise à joue de l'île afin d'afficher les nouveaux batiments uniques achetés
		 * @param list	list des batîments achetés par le joueur
		 * @param path2sprites	chemin vers les sprites
		 * @param pathfallback	autre chemin vers les sprites
		 * @param ere	l'ere à laquelle le joueur est
		 */
	public void update(ArrayList<Purchasable> list, String path2sprites, String pathfallback, Era ere) {
		this.items = list;
		String hdv ="";
		switch (ere){
			case ANTIQUITY :
				hdv="tipi.png";
				break;
			case MIDDLEAGE :
				hdv="chateau.png";
				break;
			case INDUSTRIAL :
			 	hdv="Factory.png";
				break;
			case NUMERIC :
				hdv="n7.png";
				break;
		}
		afficher_bat(hdv, 265, 70, 125, 125, true);

		for(Purchasable item : items) {
			int x = 0;
			int y = 0;
			int newH = 0;
			int newW = 0;
			String nom_image = "";
			if (item.getType()==BATIMENT.UNIQUE){
			switch (item.getName()){
				case "Pyramides" :
					x = 130;
					y = 50;
					newW = 159;
					newH = 104;
					nom_image="Pyramides.png";
					break;
				case "Colisée" :
					x = 450;
					y = 60;
					newW = 110;
					newH = 110;
					nom_image="Coliseum.png";
					break;
				case "Universal" :
					x = 0;
					y = 10;
					newW = 121;
					newH = 66;
					nom_image = "Universal.png";
					break;
				case "Tour Eiffel" :
					x = 320;
					y = -20;
					newW = 141;
					newH = 160;
					nom_image = "Tour_Eiffel.png";
					break;
				case "Robot" :
					x=110;
					y=90;
					newW = 155;
					newH = 155;
					nom_image = "Robot.png";
					break;
				case "Maoi" :
					x = 305;
					y = 190;
					newW = 90;
					newH = 90;
					nom_image = "Maoi.png";
					break;
				case "Notre-Dame" : 
					x = 370;
					y = 105;
					newW = 120;
					newH = 126;
					nom_image = "Notre_Dames.png";
					break;
				case "Empire State Building" :
					x = 50;
					y = 15;
					newW = 115;
					newH = 232;
					nom_image = "empirestate.png";
					break;
			}
			afficher_bat(nom_image, x, y, newW, newH,false);		
			}
		}	
	}
	
	}
