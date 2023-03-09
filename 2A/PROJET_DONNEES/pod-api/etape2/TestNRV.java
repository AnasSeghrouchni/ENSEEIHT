 public class TestNRV {
        IntShared_itf[] so;
        int taille;
    
        public TestNRV(int taille) {
            this.taille = taille;
            so = new IntShared_itf[taille];
            Client.init();
            for (int i = 0; i < taille; i++) {
                so[i] = (IntShared_itf)Client.create(new IntShared());
                Client.register("IntShared" + i, so[i]);
            }
        }
    }
    