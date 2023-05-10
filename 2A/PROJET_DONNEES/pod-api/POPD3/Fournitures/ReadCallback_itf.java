public interface ReadCallback_itf extends java.rmi.Remote {
    public void reponse(int v, Object obj) throws java.rmi.RemoteException;
    public int getCompteur() throws java.rmi.RemoteException;
    public int getVersion() throws java.rmi.RemoteException;
    public Object getObjet() throws java.rmi.RemoteException;
    public void setVersion(int version) throws java.rmi.RemoteException;
    public void setObjet(Object o) throws java.rmi.RemoteException;
 }