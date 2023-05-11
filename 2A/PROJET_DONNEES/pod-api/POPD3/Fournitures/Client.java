import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static Server_itf serveur;
	private static Client_itf client_this = null;
	private static HashMap<Integer, SharedObject> cache;
	private static Set<Client_itf> clients;
	private static String myName;
	public static Moniteur monitor;
	private static int version = 0;
	private static Object objet_recent = null;

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

	public void reportValue(int idObj, ReadCallback_itf rcb) throws java.rmi.RemoteException{
		SharedObject so = createOrget(idObj);
		System.out.println("ReportValue demandé chez : " + myName + " pour l'objet " + idObj);
		so.reportValue(rcb);
	}

	public void update(int idObj, int version, Object valeur, WriteCallback_itf wcb) throws java.rmi.RemoteException{
		System.out.println("Update demandé chez : " + myName);
		SharedObject so = createOrget(idObj); 
		System.out.println("Update non encore effectué");
		so.update(version, valeur, wcb);
		System.out.println("Update effectué");
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
			System.out.println("Creation envoyé au serveur : " + name);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("SharedObject avec id : " + id + " mit dans le cache");
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

	private static SharedObject createOrget(int id){
		SharedObject so = cache.get(id);
		if (so == null){
			so = new SharedObject(id, null);
			cache.put(id, so);
		}
		return so;
	}

	
	public static void write(int id, Object o) throws RemoteException{
		SharedObject so = createOrget(id);
		int v = serveur.write(id, o);	
		so.setVersion(v);	
	}

	
	public static void read(int id) throws RemoteException{
		SharedObject so = cache.get(id);
		AtomicInteger at_cpt = new AtomicInteger(0);
		for(Client_itf c : clients){
			Thread t = new Thread() {
				public void run(){
					try {
						ReadCallback rcb = new ReadCallback();
						c.reportValue(id, rcb);
						if (rcb.getReponse()){
							if (rcb.getVersion() > version){
								version = rcb.getVersion();
								objet_recent = rcb.getObjet();
								System.out.println("Modification de l'objet recent:" + version);
							}
							at_cpt.incrementAndGet();
							System.out.println("Le compteur du read callback :" + at_cpt.get());
						}

					} catch (RemoteException e) {
						e.printStackTrace();
					}
				}
			};
			t.start();
		}
		System.out.println("On att les threads lectures");
		while(at_cpt.get()<clients.size()/2){
			try {
				Thread.sleep(100);
				System.out.println("Le compteur du read callback :" + at_cpt.get());
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("On a les threads lectures");
		so.setVersion(version);
		so.setObjet(objet_recent);
	}
}