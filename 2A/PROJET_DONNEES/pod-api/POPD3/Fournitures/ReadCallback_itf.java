public interface ReadCallback_itf extends java.rmi.Remote {
    public void reponse(int version, Object o) throws java.rmi.RemoteException;
    public int getCompteur() throws java.rmi.RemoteException;
    public int getVersion() throws java.rmi.RemoteException;
    public Object getObjet() throws java.rmi.RemoteException;
 }