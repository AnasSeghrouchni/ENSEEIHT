import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class ReadCallback  implements ReadCallback_itf, Serializable{
    private static int version;
    private static Object o;
    private static int compteur;

    public ReadCallback() throws RemoteException{
        super();
        version = 0;
        o = null;
        compteur = 0;
    }

    public void reponse(int v, Object obj) throws java.rmi.RemoteException{
        synchronized(this){
            compteur++;
        }
       if (version < v){
           version = v;
           o = obj;
       }
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
