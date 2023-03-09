import java.net.*;
import java.util.Random;
import java.io.*;



public class LoadBalancer {
    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081,8082};
    static int nbHosts = 2;
    static Random rand = new Random();

    public static void  main (String[] args) {
        try{
            ServerSocket s = new ServerSocket(8080);
            while(true){
                Slave slave = new Slave(s.accept(), hosts[rand.nextInt(nbHosts)], ports[rand.nextInt(nbHosts)]);
                slave.run();
            }
            
        } catch (IOException ex) {
            ex.printStackTrace();
    }
}
}


