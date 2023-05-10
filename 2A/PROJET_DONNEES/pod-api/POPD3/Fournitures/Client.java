import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Set;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static Server_itf serveur;
	private static Client_itf client_this = null;
	private static HashMap<Integer, SharedObject> cache;
	private static Set<Client_itf> clients;
	private static String myName;
	public static Moniteur monitor;

	public Client() throws RemoteException {
		super();
		cache = new HashMap<Integer, SharedObject>();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init(String myName) {
		if (Client.client_this == null) {
			try {
				Client.client_this = new Client();
			} catch (RemoteException e) {
				e.printStackTrace();
			}
		}
		try {
			int port = 9080;
        	String URL = "//" + InetAddress.getLocalHost().getHostName() + ":" + port + "/serveur";
			serveur = (Server_itf) Naming.lookup(URL);
			cache = new HashMap<Integer, SharedObject>();
			Client.myName = myName;
			clients = serveur.addClient(Client.client_this);
			monitor = serveur.getMonitor();

		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
	}

	public void initSO(int idObj, Object valeur) throws java.rmi.RemoteException{
		SharedObject so = new SharedObject(idObj, valeur);
		cache.put(idObj, so);
	}

	public void reportValue(int idObj, ReadCallback rcb) throws java.rmi.RemoteException{
		SharedObject so = cache.get(idObj);
		if (so == null){
			so = new SharedObject(idObj, null);
			cache.put(idObj, so);
		}
		rcb.reponse(so.getVersion(), so.getObjet());
	}

	public void update(int idObj, int version, Object valeur, WriteCallback wcb) throws java.rmi.RemoteException{
		SharedObject so = cache.get(idObj);
		if (so == null){
			so = new SharedObject(idObj, null);
			cache.put(idObj, so);
		}
		if (so.getVersion() < version){
			so.setObjet(valeur);
			so.setVersion(version);
		}
		System.out.println(wcb.getCompteur());
		System.out.println(clients.size()/2);
	}

	public String getSite() throws java.rmi.RemoteException{
		return myName;
	}
	
	public Object getObj(String name) throws java.rmi.RemoteException{
		SharedObject so = lookup(name);
		if (so == null){
			return null;
		}
		return so.getObjet();
	}

	public static SharedObject publish(String name, Object o, boolean reset){
		int id = -1;
		try {
			id = serveur.publish(name, o, reset);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		SharedObject so = new SharedObject(id, o);
		cache.put(id, so);
		return so;
	}

	public int getVersion(String name) throws java.rmi.RemoteException{
		SharedObject so = lookup(name);
		if (so == null){
			return -1;
		}
		return so.getVersion();
	}


	// lookup in the name server
	public static SharedObject lookup(String name) {
		int id = -1;
		try {
			id = serveur.lookup(name);
		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
		if (id == -1) {
			return null;
		} else {
			Object o = null;
			SharedObject so = new SharedObject(id, o);
			if (!cache.containsKey(id)){
				cache.put(id, so);
			}
			return so;
		}
		
	}		

	public static String getIdSite(){
		return myName;
	}
	
	public static void write(int id, Object o) throws RemoteException{
		SharedObject so = cache.get(id);
		so.setObjet(o);
		int v = serveur.write(id, o);	
		so.setVersion(v + 1);	
	}

	public static void read(int id) throws RemoteException{
		ReadCallback rcb = new ReadCallback();
		for(Client_itf c : clients){
			Thread t = new Thread() {
				public void run(){
					try {
						c.reportValue(id, rcb);
					} catch (RemoteException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			};
			t.start();
		}
		while(rcb.getCompteur()<clients.size()/2){
		}
		SharedObject so = cache.get(id);
		so.setVersion(rcb.getVersion());
		so.setObjet(rcb.getObjet());
	}
}