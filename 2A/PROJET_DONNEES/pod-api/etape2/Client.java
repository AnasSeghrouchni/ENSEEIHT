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

	public Client() throws RemoteException {
		super();
		cache = new HashMap<Integer, SharedObject>();
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
			try {
			Object o = serveur.get_obj(id);
			Class c = o.getClass();
			String nom = c.getName();
			Class stub;
			stub = Class.forName(nom + "_stub");
			SharedObject so = (SharedObject)stub.getDeclaredConstructor(int.class, Object.class).newInstance(id,o);
			so.set_id(id);
			so.set_obj(o);
			if (!cache.containsKey(id)){
				cache.put(id, so);
			}
			return so;
			} catch (Exception e) {
				e.printStackTrace();
				return null;
			}
		}
	}		
	
	// binding in the name server
	public static void register(String name, Object o) {
		try {
			serveur.register(name, ((SharedObject)o).get_id());
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
			Class c = o.getClass();
			String nom = c.getName();
			Class stub = Class.forName(nom + "_stub");
			so = (SharedObject)stub.getDeclaredConstructor(int.class, Object.class).newInstance(id,o);
			so.set_id(id);
			so.set_obj(o);
			cache.put(id, so);
		} catch (Exception e) {
			System.err.println("Client exception: " + e.toString());
			e.printStackTrace();
		}
		return so;
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