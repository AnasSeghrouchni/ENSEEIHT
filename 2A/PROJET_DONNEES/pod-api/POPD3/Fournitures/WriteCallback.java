import java.io.Serializable;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class WriteCallback extends UnicastRemoteObject implements WriteCallback_itf{
    private boolean reponse;

    public WriteCallback() throws RemoteException{
        super();
        this.reponse = false;
    }

    public synchronized void reponse() throws java.rmi.RemoteException{
        this.reponse = true;    
    }

    public boolean getReponse(){
        return this.reponse;
    }

}  
