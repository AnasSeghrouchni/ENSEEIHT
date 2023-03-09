import java.net.*;


public class Slave extends Thread {
    Socket csock;
    int bytesRead;
    int serverAnswer;
    String host;
    int port;
    public Slave(Socket s, String host, int port) {
        this.csock = s;
        this.host = host;
        this.port = port;
    }

    public void run() {
        try{
        
            int bytesRead;
            Socket ssock = new Socket(host, port);
            byte[] buf = new byte[1024];
            byte[] buffer = new byte[1024];
            bytesRead = csock.getInputStream().read(buf);
            ssock.getOutputStream().write(buf, 0, bytesRead);
            serverAnswer = ssock.getInputStream().read(buffer);
            csock.getOutputStream().write(buffer, 0, serverAnswer);
            csock.close();
            ssock.close();
        }catch (Exception ex) {
            ex.printStackTrace();
        }
        }

    }