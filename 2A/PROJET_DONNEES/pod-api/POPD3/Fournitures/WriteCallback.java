import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class WriteCallback implements WriteCallback_itf, Serializable{
    private static int compteur;

    public WriteCallback() throws RemoteException{
        super();
        compteur = 0;
    }

    public void reponse() throws java.rmi.RemoteException{
        synchronized(this){
            compteur++;
        }
    }

    public int getCompteur(){
        return compteur;
    }
}  
