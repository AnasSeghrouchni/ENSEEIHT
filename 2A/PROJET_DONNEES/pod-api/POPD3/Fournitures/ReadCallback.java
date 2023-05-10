import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class ReadCallback  implements ReadCallback_itf, Serializable{
    private int version;
    private Object o;
    private int compteur;

    public ReadCallback() throws RemoteException{
        super();
        this.version = 0;
        this.o = null;
        this.compteur = 0;
    }

    public void reponse(int version, Object o) throws java.rmi.RemoteException{
       this.compteur++;
       if (this.version < version){
           this.version = version;
           this.o = o;
       }
    }  
    
    public int getCompteur(){
        return this.compteur;
    }

    public int getVersion(){
        return this.version;
    }

    public Object getObjet(){
        return this.o;
    }
}
