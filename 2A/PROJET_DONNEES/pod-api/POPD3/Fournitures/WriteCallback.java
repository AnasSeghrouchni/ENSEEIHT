import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class WriteCallback implements WriteCallback_itf, Serializable{
    private int compteur;

    public WriteCallback() throws RemoteException{
        super();
        this.compteur = 0;
    }

    public void reponse() throws java.rmi.RemoteException{
        this.compteur++;
    }

    public int getCompteur(){
        return this.compteur;
    }
}  
