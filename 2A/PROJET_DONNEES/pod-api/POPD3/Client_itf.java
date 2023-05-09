public interface Client_itf extends java.rmi.Remote {
	public void initialiser_un_objet(int idObjet, Object o) throws java.rmi.RemoteException;
	public void enquete(int idObjet, RappelLct cbl) throws java.rmi.RemoteException;
	public void mise_a_jour(int idObjet, int version, Object o, RappelEcr cbr) throws java.rmi.RemoteException;
}
