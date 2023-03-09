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
    private List<Client_itf> abonnes;

    private Client_itf ecrivain;


    public ServerObject(int id, Object o) {
        this.id = id;
        this.obj = o;
        this.verrou = Locks.NL;
        this.lecteurs = new ArrayList<>();
        this.abonnes = new ArrayList<>();
        this.ecrivain = null;

    }

    public void follow(Client_itf client){
        if (!this.abonnes.contains(client)){
            this.abonnes.add(client);
        }
        else {
            System.out.println("Déjà abonné");
        }
    }

    public void unfollow(Client_itf client){
        if (this.abonnes.contains(client)){
            this.abonnes.remove(client);
        }
        else {
            System.out.println("Vous n'êtes pas encore abonné");
        }
    }

    class MyThread extends Thread {
        Client_itf c;
        int id;
        Object obj;

    public MyThread(Client_itf c, int i, Object o){
        this.c = c;
        this.id = i;
        this.obj = o;
    }

    public void run(){
        try{
            c.notifier(id,obj);
        } 
        catch (Exception e){
             e.printStackTrace();
        }
    }
  }
 

    public void maj(){
        for (Client_itf c : abonnes){
                if (!c.equals(ecrivain)) {
                    Thread t = new MyThread(c,id,obj);
                    t.run();
                }
        }
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
                    Object objet = ecrivain.reduce_lock(this.id);
                    if (objet != null) {
                        this.obj = objet;
                    }
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
                    Object objet = ecrivain.invalidate_writer(this.id);
                    if (objet != null) {
                        this.obj = objet;
                    }
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

}
