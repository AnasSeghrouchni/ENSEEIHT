import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

public class ServerObject {

    private int id;
    private Object o;
    private int version;

    public ServerObject(int id, Object o) {
        this.id = id;
        this.o = o;
        this.version = 0; 
    }

    public void maj(Object o){
        this.o = o;
        this.version++;
    }

    public void reset(Object o){
        this.o = o;
        this.version = 0;
    }

    public int getVersion(){
        return this.version;
    }

}
