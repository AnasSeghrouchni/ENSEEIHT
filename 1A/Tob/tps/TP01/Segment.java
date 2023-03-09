import java.awt.Color;

/** Un segment est défini pas ses deux points qui constituent ses
 * extrémités.  Un segment peut être affiché et translaté.
 *
 * @author	Xavier Crégut
 * @version	1.9
 */
public class Segment {

	private Point extremite1;
	private Point extremite2;
	private Color couleur;

	/**  Construire un Segment à partir de ses deux points extrémités.
	 *  @param ext1	le premier point extrémité
	 *  @param ext2	le deuxième point extrémité
	 */
	public Segment(Point ext1, Point ext2) {
		this.extremite1 = ext1;
		this.extremite2 = ext2;
		this.couleur = Color.green;
	}

   /** Translater le segment.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
	public void translater(double dx, double dy) {
		this.extremite1.translater(dx, dy);
		this.extremite2.translater(dx, dy);
	}

	/** Obtenir la longueur du segment.
	 * @return la longueur du segment
	 */
	public double longueur() {

		return (this.extremite2.distance(this.extremite1));
	}

	/** Afficher le segment.  Le segment est affiché sous la forme :
	 * <PRE>
	 *		[extremite1-extremite2]
	 * </PRE>
	 */
	public void afficher() {
	double p1x= this.extremite1.getX();
	double p1y= this.extremite1.getY();
	double p2x= this.extremite2.getX();
	double p2y= this.extremite2.getY();
	System.out.print("[("+p1x+","+p1y+")-("+p2x+","+p2y+")]");
	}

	/** Obtenir la couleur du segment.
	 * @return la couleur du segment
	 */
	public Color getCouleur() {
		return this.couleur;
	}

	/** Changer la couleur du segment.
	 * @param nouvelleCouleur nouvelle couleur
	 */
	public void setCouleur(Color nouvelleCouleur) {
		this.couleur = nouvelleCouleur;
	}

}
