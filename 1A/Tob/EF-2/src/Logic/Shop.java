package Logic;


import java.nio.file.NoSuchFileException;
import java.util.ArrayList;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import Utils.Utils;

public class Shop {

    public enum ResearchState {
        ACTIVE,
        DONE,
        NONE
    }

    ArrayList<Purchasable> items;

    private Purchasable researched = null; //le purchasable entrain d'être débloqué
    private int researchTicksLeft; //le nombre de ticks restant avant la fin de la recherche
    private ResearchState researchState = ResearchState.NONE;

    public Shop() {
        Gson gson = new Gson();
        // on lit le contenu du fichier JSON
        String json = "";
        // permet de régler le probleme de path différents selon la config du projet
        try {
            json = Utils.readFile("src/Content/purchasables.json");
        } catch (NoSuchFileException e1) {
            try {
                json = Utils.readFile("./Content/purchasables.json");
            } catch (NoSuchFileException e2) {
                System.exit(-1);
            }
        }

        // on crée l'objet a partir des données du JSON
        items = gson.fromJson(json, new TypeToken<ArrayList<Purchasable>>(){}.getType());

        // TODO TESTS A DELETE:
       //Bonus[] bonuses = {new Bonus(Bonus.BonusStat.FOOD, 10, 0.5f)};
       //Purchasable test = new Purchasable("food upgrade", bonuses, 100);
       //System.out.println(gson.toJson(test));
    }

    public Shop(String json) {
        Gson gson = new Gson();
        // on crée l'objet a partir des données du JSON
        items = gson.fromJson(json, new TypeToken<ArrayList<Purchasable>>(){}.getType());
    }

    // private void add(Purchasable p){
    //     this.items.add(p);
    // }

    /**
     * Lancer la recherche d'un purchasable
     * @param p purchasable à rechercher
     */
    public void startResearch(Purchasable p){
        this.setResearch(p);
    }

    /**
     * Annuler la recherche en cours.
     */
    public void cancelResearch() {
        this.resetResearch();
    }

    private void setResearch(Purchasable p) {
        // vérifier l'ère
        if(isPurchasable(p)) {
            System.out.println("Started research for " + p.getName());
            this.researched = p;
            this.researchTicksLeft = p.getPrice();
            this.researchState = ResearchState.ACTIVE ;
        } else {
            System.out.println("NOT PURCHASABLE !");
        }
        // peut être ajouter un throw sinon
    }

    private void resetResearch() {
        this.researched = null;
        this.researchTicksLeft = 0;
        this.researchState = ResearchState.NONE;
    }

    private void researchDone(Purchasable p) {
        Game.run.addPurchase(p);
        this.researchState = ResearchState.DONE;
        this.researched = null;
        System.out.println("Research done for " + p.getName());

    }

    public void tick() {
        if(researchState == ResearchState.ACTIVE) {
            this.researchTicksLeft -= Run.stats.getCurrentProduction();
            System.out.println("Research time left for " + this.researched.getName() + " : " + this.getResearchTicksLeft());
            if(this.researchTicksLeft <= 0) {
                researchDone(this.researched);
            }
        }
    }

    /**
     * Retourne si un purchasable est disponible à l'achat (dans la même ère, non déjà achetés et non en cours de recherche).
     * @param p le purchasable
     * @return Boolean: True si achetable, False sinon
     */
    public boolean isPurchasable(Purchasable p) {
//        // DEBUG
//        if(p.isPurchased()) {
//            System.out.println("DEJA ACHETE");
//        }
//        if(p.getEra() != Game.run.getEra()) {
//            System.out.println("MAUVASE ERE p: " + p.getEra() + " run: " + Game.run.getEra());
//        }
//        if( p == this.researched) {
//            System.out.println("EN COURS DE RECHERCHE");
//        }
        return !p.isPurchased() && p.getEra() == Game.run.getEra() && p != this.researched;
    }

    /**
     * Retourne les items qui sont disponible à l'achat (dans la même ère, non déjà achetés et non en cours de recherche).
     * @return ArrayList<Purchasable> purchasableItems
     */
    public ArrayList<Purchasable> getPurchasableItems() {
        ArrayList<Purchasable> purchasableItems = new ArrayList<Purchasable>();
        for (Purchasable p: this.items) {
            if(isPurchasable(p)){
                purchasableItems.add(p);
            }
        }
        return purchasableItems;
    }

    /**
     * Retourne les items déjà achetés.
     * @return ArrayList<Purchasable> purchasedItems
     */
    public ArrayList<Purchasable> getPurchasedItems() {
//        ArrayList<Purchasable> purchasedItems = new ArrayList();
//        for (Purchasable p: this.items) {
//            if(p.isPurchased()){
//                purchasedItems.add(p);
//            }
//        }
//        return purchasedItems;

        return Game.run.getPurchased();
    }

    /**
     * Retourne l'état de la recheche: ACTIVE, DONE ou NONE
     * @return ResearchState
     */
    public ResearchState getResearchState() {
        return this.researchState;
    }

    public Purchasable getResearched() {
        return this.researched;
    }

    public int getResearchTicksLeft() {
        return this.researchTicksLeft;
    }

    public ArrayList<Purchasable> getItems() {
        return this.items;
    }

}
