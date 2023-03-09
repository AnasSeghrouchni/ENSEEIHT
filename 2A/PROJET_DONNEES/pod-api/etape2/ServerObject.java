import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

public class ServerObject {

    enum Locks {
		NL,
		RL,
		WL,
	}

    private Locks verrou;
    private int id;
	private Object obj;
    private List<Client_itf> lecteurs;
    private Client_itf ecrivain;


    public ServerObject(int id, Object o) {
        this.id = id;
        this.obj = o;
        this.verrou = Locks.NL;
        this.lecteurs = new ArrayList<>();
        this.ecrivain = null;

    }

    public synchronized Object lock_read(Client_itf client){
        switch(verrou) {
            case NL :
                lecteurs.add(client);
                verrou = Locks.RL;
                return obj;
            case RL :
                lecteurs.add(client);
                return obj;
            case WL :
                try {
                    obj = ecrivain.reduce_lock(this.id);
                    lecteurs.add(ecrivain);
                    lecteurs.add(client);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                verrou = Locks.RL;
                return obj;
            default :
                System.out.println("Non");
                return null;  
        }
    }

    public synchronized Object lock_write(Client_itf client){
        if (lecteurs.contains(client)){
            lecteurs.remove(client);
        }
        switch(verrou) {
            case NL :
                ecrivain = client;
                verrou = Locks.WL;
                break;
            case RL :
                for(Client_itf c : lecteurs){
                    try {
                        c.invalidate_reader(this.id);
                    } catch (RemoteException e) {
                        e.printStackTrace();
                    }
                }
                ecrivain = client;
                verrou = Locks.WL;
                break;
            case WL :
                try {
                    obj = ecrivain.invalidate_writer(this.id);
                    ecrivain = client;
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                break;
            default :
                System.out.println("Non");
        }
        this.lecteurs.clear();
        return obj;
    }

    public Object get_obj() {
        return obj;
    }

}
