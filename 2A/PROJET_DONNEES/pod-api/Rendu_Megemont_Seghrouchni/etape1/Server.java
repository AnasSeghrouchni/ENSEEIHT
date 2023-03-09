import java.net.InetAddress;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

import javax.lang.model.util.ElementScanner6;

public class Server extends UnicastRemoteObject implements Server_itf{

    private int cpt;
    private HashMap<String, Integer> noms_to_id;
    private HashMap<Integer, ServerObject> id_to_so;
 

    public Server() throws java.rmi.RemoteException {
        super();
        cpt = 0;    
        noms_to_id = new HashMap<String, Integer>();
        id_to_so = new HashMap<Integer, ServerObject>();
    }

    public int lookup(String name) throws java.rmi.RemoteException {
        Object i = noms_to_id.get(name);
        if (i == null){
            return -1;
        }else {
            return (int) i;
        }
        
    }

    public void register(String name, int id) throws java.rmi.RemoteException {
        System.out.println("Enregisterement objet "+name+", n°"+id);
        noms_to_id.put(name, id);
    }

    public int create(Object o) throws java.rmi.RemoteException{
        int id;
        synchronized(this){
            id = cpt;
            cpt++;
        }
        ServerObject so = new ServerObject(id, o);
        id_to_so.put(id, so);
        return id;
    }

    public Object lock_read(int id, Client_itf client) throws java.rmi.RemoteException{
        ServerObject so = id_to_so.get(id);
        return so.lock_read(client);
    }

    public Object lock_write(int id, Client_itf client) throws java.rmi.RemoteException{
        ServerObject so = id_to_so.get(id);
        return so.lock_write(client);
    }

    public void follow(int id, Client_itf client) throws java.rmi.RemoteException{
        ServerObject so = id_to_so.get(id);
        so.follow(client);
    }

    public void unfollow(int id, Client_itf client) throws java.rmi.RemoteException{
        ServerObject so = id_to_so.get(id);
        so.unfollow(client);
    }

    public void maj(int id){
        ServerObject sero = id_to_so.get(id);
        sero.maj();
    }

    public static void main(String[] args) throws UnexpectedException{
        int port = 9080;
        String URL;
        try {
            Registry registry = LocateRegistry.createRegistry(port);
        } catch (Exception e) {
            System.err.println("Serveur exception: " + e.toString());
            e.printStackTrace();
        }
        try {
            Server serveur = new Server();
            URL = "//" + InetAddress.getLocalHost().getHostName() + ":" + port + "/serveur";
            Naming.rebind(URL, serveur);
            System.out.println("Serveur ok");
        } catch (Exception e) {
            System.err.println("Serveur exception: " + e.toString());
            e.printStackTrace();
    }
}
}