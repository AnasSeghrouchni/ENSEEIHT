import java.util.Random;

public class Accessor {

    public static void modifier(IntShared_itf s,IntShared_itf s0, int n) {
        ((IntShared_itf)s).write(n);
        ((IntShared_itf)s0).write(n);
    }

    public static void afficher(IntShared_itf[] t){
        int somme = 0;
        for (int i = 1; i<10; i++){
            somme += ((IntShared_itf)t[i]).read();
        }
        System.out.print(somme + "->");
        System.out.println(((IntShared_itf)t[0]).read());    
    }
    
    public static void main(String[] argv){
        IntShared_itf[] tab = new IntShared_itf[10];
        Random rand = new Random();
        Client.init();   
        for (int i = 0; i<10; i++){
            tab[i] =  (IntShared_itf)Client.lookup("IntShared" + i);
        }
        if (argv.length == 0) {
        for (int i = 0; i < 5; i++) {
            int n = rand.nextInt(1000);
            int r = rand.nextInt(8) + 1;
            modifier(tab[r], tab[0], n);
        }
        }
        else {
        afficher(tab);
    }
    }
}
