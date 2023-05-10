import java.net.InetAddress;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

import javax.lang.model.util.ElementScanner6;

public class Server extends UnicastRemoteObject implements Server_itf{

    private int cpt;
    private static int nbClients;
    private Set<Client_itf> clients = new HashSet<Client_itf>();
    private HashMap<String, Integer> noms_to_id;
    private HashMap<Integer, ServerObject> id_to_so;
    private Moniteur moniteur;
 

    public Server() throws java.rmi.RemoteException {
        super();
        cpt = 0;    
        noms_to_id = new HashMap<String, Integer>();
        id_to_so = new HashMap<Integer, ServerObject>();
    }

    public Set<Client_itf> addClient(Client_itf client) throws java.rmi.RemoteException{
        synchronized(this){
        clients.add(client);
        if (clients.size() < nbClients){
            try {
                wait();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        else{
            notifyAll();
        }
        return clients;
    }
    }   
    
    public int lookup(String name) throws RemoteException{
        return noms_to_id.get(name);
    }

    public int publish(String name, Object o, boolean reset) throws RemoteException{
        if (noms_to_id.containsKey(name)){
            int id = noms_to_id.get(name);
            ServerObject sero = id_to_so.get(id);
            if (reset){
                sero.reset(o);
            }
            return id;
        }
        else{
            
            ServerObject sero = new ServerObject(cpt, o);
            noms_to_id.put(name, cpt);
            id_to_so.put(cpt, sero);
            cpt++;
            return cpt-1;
        }
    }

    public String[] list() throws RemoteException{
        String[] noms = new String[noms_to_id.size()];
        return noms_to_id.keySet().toArray(noms);
    }

 

    public int write(int id, Object o) throws RemoteException{
        synchronized(this){
        ServerObject sero = id_to_so.get(id);
        sero.maj(o);
        int v = sero.getVersion();
        WriteCallback wcb = new WriteCallback();
        for(Client_itf c : clients){
				Thread t = new Thread() {
					public void run(){
						try {
							c.update(id, v, o, wcb);
                            wcb.reponse();
						} catch (RemoteException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				};
				t.start();
		}
		while(wcb.getCompteur()<clients.size()/2){
		}
        return sero.getVersion();
        }
    }

    public Set<Client_itf> setMonitor(Moniteur m) throws RemoteException{
        synchronized(this){
        this.moniteur = m;
        if (clients.size() < nbClients){
            try {
                wait();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        else{
            notifyAll();
        }
        return clients;
    }
    }
	public Moniteur getMonitor() throws RemoteException{
        return moniteur;
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
            if (args.length != 1) {
                System.out.println("java Server <nb of clients>");
                return;
            }
            Server.nbClients = Integer.parseInt(args[0]);
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