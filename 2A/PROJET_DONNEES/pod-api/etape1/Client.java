import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.time.chrono.ThaiBuddhistChronology;
import java.util.HashMap;
import java.rmi.registry.*;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static Server_itf serveur;
	private static Client_itf client_this = null;
	private static HashMap<Integer, SharedObject> cache;
	private static HashMap<Integer, Runnable> run;

	public Client() throws RemoteException {
		super();
		cache = new HashMap<Integer, SharedObject>();
		run = new HashMap<Integer, Runnable>();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init() {
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

		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
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
	
	// binding in the name server
	public static void register(String name, SharedObject_itf so) {
		try {
			serveur.register(name, so.get_id());
		} catch (RemoteException e) {
			e.printStackTrace();
		}
	}

	// creation of a shared object
	public static SharedObject create(Object o) {
		int id = -1;
		SharedObject so = null;
		try {
			id = serveur.create(o);
			so = new SharedObject(id, o);
			cache.put(id,so);
		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
		return so;
	}

	// follow an object
	public static void follow(int id, Runnable r) {
		try{
			run.put(id,r);
			serveur.follow(id, client_this);
		} catch(Exception e){
			System.err.println("Client follow exception: " + e.toString());
			e.printStackTrace();
		}
	}

	public static void unfollow(int id) {
		try{
			serveur.unfollow(id, client_this);
		} catch(Exception e){
			System.err.println("Client follow exception: " + e.toString());
			e.printStackTrace();
		}
	}

	//prévenir des mises à jour des objets des abonnés
	public void notifier(int id, Object obj){
		run.get(id).run();
		SharedObject so = cache.get(id);
		so.obj = obj;
	}

	public static void maj(int id){
		try{
			serveur.maj(id);
		} catch(Exception e){
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	// request a read lock from the server
	public static Object lock_read(int id) {
		Object o = null;
		try {
			o = serveur.lock_read(id, client_this);
			SharedObject so = cache.get(id);
			so.obj = o;
		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
		return o;
	}

	// request a write lock from the server
	public static Object lock_write (int id) {
		Object o = null;
		try {
			o = serveur.lock_write(id, client_this);
			SharedObject so = cache.get(id);
			so.obj = o;
		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
		return o;
	}

	// receive a lock reduction request from the server
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		return cache.get(id).reduce_lock();
	}


	// receive a reader invalidation request from the server
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		cache.get(id).invalidate_reader();
	}


	// receive a writer invalidation request from the server
	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		return cache.get(id).invalidate_writer();
	}
}