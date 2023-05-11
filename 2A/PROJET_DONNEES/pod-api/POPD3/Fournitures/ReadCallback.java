import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class ReadCallback extends UnicastRemoteObject implements ReadCallback_itf{
    private static int version;
    private static Object o;
    private static int compteur;
    private boolean reponse;

    public ReadCallback() throws RemoteException{
        super();
        version = 0;
        o = null;
        compteur = 0;
        this.reponse = false;
    }

    public void reponse(int v, Object obj) throws java.rmi.RemoteException{
       if (version < v){
           version = v;
           o = obj;
       }
         this.reponse = true;
         System.out.println("reponse");
    } 

    public boolean getReponse(){
        return this.reponse;
    }
    
    public int getCompteur() throws java.rmi.RemoteException{
        return compteur;
    }

    public int getVersion() throws java.rmi.RemoteException{
        return version;
    }

    public void setVersion(int v) throws java.rmi.RemoteException{
        version = v;
    }

    public void setObjet(Object obj) throws java.rmi.RemoteException{
        o = obj;
    }

    public Object getObjet() throws java.rmi.RemoteException{
        return o;
    }
}
