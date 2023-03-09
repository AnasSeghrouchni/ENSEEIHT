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
		this.id = id;
		this.obj = o;
		verrou = Lock.NL;
	}
	
	// invoked by the user program on the client node
	public synchronized void lock_read() {
		switch(verrou) {
			case NL :
				obj = Client.lock_read(id);
				verrou = Lock.RLT;
				break;
			case RLC :
				verrou = Lock.RLT;
				break;
			case WLC :
				verrou = Lock.RLT_WLC;
				break;
			case WLT :
				System.out.println("Il faut d'abord unlock pour lire : WLT");
				break;
			default :
				System.out.println("Il faut d'abord unlock pour lire");
		}

	}

	// invoked by the user program on the client node
	public void lock_write() {
		synchronized(this){
		switch(verrou) {
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
			obj = Client.lock_write(id);
			synchronized(this){
			if (obj != null){
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
				verrou = Lock.WLC;
				break;
			default :
				System.out.println("Non");
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
		System.out.println("invalidate_reader sur " + id);
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
				break;
			case RLC :
				verrou = Lock.NL;
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
				break;
			case WLC :
				System.out.println("invalidate_reader : ne s'applique pas sur un ecrivain WLC");
				break;
			case WLT :
				System.out.println("invalidate_reader : ne s'applique pas sur un ecrivain WLT");
				break;
			default :
				System.out.println("Il faut d'abord unlock");
		}
	}

	public synchronized Object invalidate_writer() {
		System.out.println("invalidate_writer sur " + id);
		switch(verrou) {
			case NL :
				while (verrou != Lock.WLC) {
				try {
					wait();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			System.out.println("invalidate_writer sur NL ");
			verrou = Lock.NL;
			break;
			case RLC :
				System.out.println("invalidate_writer : ne s'applique pas sur un lecteur");
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
				verrou = Lock.NL;
				break;
			default :
			System.out.println("Il faut d'abord unlock");
	}
	return obj;
}

public int get_id(){
	return id;
}

public void set_id(int id){
	this.id = id;
}

public void set_obj(Object obj){
	this.obj = obj;
}
}