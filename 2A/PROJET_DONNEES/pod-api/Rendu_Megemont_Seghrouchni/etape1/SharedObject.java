import java.io.*;
import java.nio.file.NotLinkException;
import java.text.Normalizer;

public class SharedObject implements Serializable, SharedObject_itf {

	enum Lock {
		NL,
		WLC,
		RLC,
		WLT,
		RLT,
		RLT_WLC
	}
	
	public int id;
	private Lock verrou;
	public Object obj;

	public SharedObject(int id, Object o) {
		super();
		this.obj = o;
		verrou = Lock.NL;
	}
	
	// invoked by the user program on the client node
	public synchronized void lock_read() {
		switch(verrou) {
			case NL :
				obj = Client.lock_read(id);
				verrou = Lock.RLT;
				return;
			case RLT :
				System.out.println("Il faut d'abord unlock pour lire : RLT");
				return;
			case RLC :
				verrou = Lock.RLT;
				return;
			case WLC :
				verrou = Lock.RLT_WLC;
				return;
			case WLT :
				System.out.println("Il faut d'abord unlock pour lire : WLT");
				return;
			default :
				return;
	}
		
	}

	// invoked by the user program on the client node
	public void lock_write() {
		synchronized(this){
		switch(verrou) {
			case RLT :
				System.out.println("Il faut d'abord unlock pour ecrire : RLT");
				return;
			case RLT_WLC :
				System.out.println("Il faut d'abord unlock pour ecrire : RLT_WLC");
				return;	
			case WLC :
				verrou = Lock.WLT;
				return;
			case WLT :
				System.out.println("Il faut d'abord unlock pour ecrire : WLT");
				return;
			default :
				break;
		}
		}
		while(verrou != Lock.WLT){
			Object objet = Client.lock_write(id);
			synchronized(this){
			if (objet != null){
				obj = objet;
				verrou = Lock.WLT;
			}
			}			
		}
	}

	// invoked by the user program on the client node
	public synchronized void unlock() {
		switch(verrou) {
			case NL :
				break;
			case RLC :
				break;
			case RLT_WLC :
				verrou = Lock.WLC;
				break;
			case WLC :
				break;
			case RLT :
				verrou = Lock.RLC;
				break;
			case WLT :
				Client.maj(id);
				verrou = Lock.WLC;
				break;
			default :
				break;
		}
		try{
			notify();
		}
		catch(Exception e){
			e.printStackTrace();
		}	
	}


	// callback invoked remotely by the server
	public synchronized Object reduce_lock() {
		switch(verrou) {
			case NL :
				break;
			case RLC :
				break;
			case RLT_WLC :
				verrou = Lock.RLT;
				break;
			case RLT :
				break;
			case WLC :
				verrou = Lock.RLC;
				break;
			case WLT :
				while (verrou == Lock.WLT) {
					try {
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				Client.maj(id);
				verrou = Lock.RLC;
				break;
			default :
				System.out.println("Il faut d'abord unlock");
		}
		try {
			notify();
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}

	// callback invoked remotely by the server
	public synchronized void invalidate_reader() {
		switch(verrou) {
			case NL :
				while (verrou != Lock.RLC) {
					try {
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				verrou = Lock.NL;
				obj = null;
				break;
			case RLC :
				verrou = Lock.NL;
				obj = null;
				break;
			case RLT_WLC :
				break;
			case RLT :
				while (verrou == Lock.RLT) {
					try {
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				verrou = Lock.NL;
				obj = null;
				break;
			case WLC :
				verrou = Lock.NL;
				obj = null;
				break;
			case WLT :
				System.out.println("invalidate_reader : ne s'applique pas sur un ecrivain WLT");
				break;
			default :
				System.out.println("Il faut d'abord unlock");
		}
	}

	public synchronized Object invalidate_writer() {
		switch(verrou) {
			case NL :
				while (verrou != Lock.WLC) {
				try {
					wait();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			verrou = Lock.NL;
			break;
			case RLC :
				verrou = Lock.NL;
				break;
			case RLT_WLC :
				while (verrou == Lock.RLT_WLC) {
					try {
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				verrou = Lock.NL;
				break;
			case RLT :
				System.out.println("invalidate_writer : ne s'applique pas sur un lecteur");
				break;
			case WLC :
				verrou = Lock.NL;
				break;
			case WLT :
				while (verrou == Lock.WLT) {
					try {
						wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				Client.maj(id);
				verrou = Lock.NL;
				break;
			default :
			System.out.println("Il faut d'abord unlock");
	}
	Object objet = this.obj;
	obj = null;
	return objet;
}

public void follow(Runnable r){
	Client.follow(id,r);
}

public void unfollow(){
	Client.unfollow(id);
}

public int get_id(){
	return id;
}
}