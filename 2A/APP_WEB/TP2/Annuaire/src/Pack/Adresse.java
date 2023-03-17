package Pack;

public class Adresse {
	private String rue;
	private String ville;
	private int id;
	
	public Adresse(String r, String v, int id) {
		this.rue = r;
		this.ville = v;
		this.id = id;
	}
	
	public String getRue() {
		return this.rue;
	}
	
	public String getVille() {
		return this.ville;
	}
	
	public void setRue(String r) {
		this.rue = r;
	}
	
	public void setVille(String r) {
		this.ville = r;
	}

}
