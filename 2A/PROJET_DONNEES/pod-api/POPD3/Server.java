import java.net.InetAddress;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

import javax.lang.model.util.ElementScanner6;

public class Server extends UnicastRemoteObject implements Server_itf{

    private int cpt;
    private Set<Client_itf> clients = new HashSet<Client_itf>();
    private HashMap<String, Integer> noms_to_id;
    private HashMap<Integer, ServerObject> id_to_so;
 

    public Server() throws java.rmi.RemoteException {
        super();
        cpt = 0;    
        noms_to_id = new HashMap<String, Integer>();
        id_to_so = new HashMap<Integer, ServerObject>();

    }

    public Set<Client_itf> addClient(Client_itf client) throws java.rmi.RemoteException{
        clients.add(client);
        return clients;
    }

    public int publish(String name, Object o, boolean reset) throws RemoteException{
        if (noms_to_id.containsKey(name)){
            int id = noms_to_id.get(name);
            ServerObject sero = id_to_so.get(id);
            if (reset){
                sero.reset(o);
            }
            else{
                sero.maj(o);
            }
            return id;
        }
        else{
            cpt++;
            ServerObject sero = new ServerObject(cpt, o);
            noms_to_id.put(name, cpt);
            id_to_so.put(cpt, sero);
            return cpt;
        }
    }

    public void lookup(String name) throws RemoteException{
        return noms_to_id.get(name);
    }

    public int write(int id, Object o) throws RemoteException{
        ServerObject sero = id_to_so.get(id);
        sero.maj(o);
        return sero.getVersion();
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