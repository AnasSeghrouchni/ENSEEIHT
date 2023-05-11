import java.io.*;
import java.util.concurrent.Semaphore;
import java.util.Set;
import java.rmi.RemoteException;


public class SharedObject implements Serializable, SharedObject_itf {

    private static final long serialVersionUID = 1L;
    private int id;
    public Object obj;
    private int version;


    public SharedObject(int id, Object o) {
        this.id = id;
        this.obj = o;
        this.version = 0;
    }

    public Object getObjet() {
        return obj;
    }

    public void setObjet(Object o) {
        this.obj = o;
    }

    public int getId() {
        return id;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int v) {
        version = v;
    }

    public void update(int v, Object valeur, WriteCallback_itf wcb) {
        try {
            Client.monitor.feuVert(Client.getIdSite(),4); // ** Instrumentation
         	// ** attente quadruplée pour les ack, pour exhiber l'inversion de valeurs
         	// getIdSite identique à getSite, mais non Remote
         	
         	// suite de la méthode update... 
             if (this.version < v){
                this.obj = valeur;
                this.version = v;
                System.out.println("Update effectué");
            }
            wcb.reponse();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        
    }

    public void reportValue(ReadCallback_itf rcb) {
        try {
            Client.monitor.feuVert(Client.getIdSite(),1); // ** Instrumentation
            rcb.reponse(version, obj);

         	// suite de la méthode reportValue... 
         	
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    // invoked by the user program on the client node
    // passage par Client pour que les écritures soient demandées en séquence sur le site
    public void write(Object o) {
        try {
            Client.monitor.signaler("DE",Client.getIdSite(),version); // ** Instrumentation
            Client.write(id,o);
            Client.monitor.signaler("TE",Client.getIdSite(),version); // ** Instrumentation
        } catch (RemoteException rex) {
            rex.printStackTrace();
        }
    }

    // pour simplifier (éviter les ReadCallBack actifs simultanés)
    // on évite les lectures concurrentes sur une même copie
    public synchronized Object read() {
        // déclarations méthode read....


        try {
            Client.monitor.signaler("DL",Client.getIdSite(),version); // ** Instrumentation
            Client.read(id);
            Client.monitor.signaler("TL",Client.getIdSite(),version); // ** Instrumentation
            return obj;
        } catch (RemoteException rex) {
            rex.printStackTrace();
            return null;
        }
    }

}