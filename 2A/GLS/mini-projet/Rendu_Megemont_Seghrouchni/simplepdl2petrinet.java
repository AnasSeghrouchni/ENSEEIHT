package simplepdl.manip;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import simplepdl.Process;
import simplepdl.Ressource;
import simplepdl.RessourceUtile;
import simplepdl.WorkDefinition;
import simplepdl.WorkSequence;
import simplepdl.WorkSequenceType;
import simplepdl.SimplepdlFactory;
import simplepdl.SimplepdlPackage;
import petrinet.*;

public class simplepdl2petrinet {
	public static Process recupererSimplePDL() {
		// Chargement du package SimplePDL afin de l'enregistrer dans le registre d'Eclipse.
		SimplepdlPackage packageInstance = SimplepdlPackage.eINSTANCE;
		
		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		
		// CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (notre modÃ¨le)
		ResourceSet resSet = new ResourceSetImpl();

		// Charger la ressource (notre modÃ¨le)
		URI modelURI = URI.createURI("models/Exemple_enonce.xmi");
		Resource resource = resSet.getResource(modelURI, true);
		
		// RÃ©cupÃ©rer le premier Ã©lÃ©ment du modÃ¨le (Ã©lÃ©ment racine)
		Process process = (Process) resource.getContents().get(0);
		return process;
	}
	
	public static Resource creerXmi() {
		// Charger le package PertriNet afin de l'enregistrer dans le registre d'Eclipse.
		PetrinetPackage packageInstance = PetrinetPackage.eINSTANCE;
		
		// Enregistrer l'extension ".xmi" comme devant être ouverte à
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		
		// Créer un objet resourceSetImpl qui contiendra une ressource EMF (le modle)
		ResourceSet resSet = new ResourceSetImpl();

		// DÃ©finir la ressource (le modele)
		URI modelURI = URI.createURI("models/Process2Petri_java.xmi");
		Resource ressource = resSet.createResource(modelURI);
		return ressource;
	}
	
	public static void main(String[] args){
		
		Process process = recupererSimplePDL();
		Resource resource = creerXmi();
		
		
		// La fabrique pour fabriquer les Ã©lÃ©ments de petrinet
	    PetrinetFactory myFactory = PetrinetFactory.eINSTANCE;
	    
		// Créer un élement ReseauPetri
		ReseauPetri petri = myFactory.createReseauPetri();
		
		//Donner le même nom au réseau de petri que celui du process
		petri.setName(process.getName());
		
		// Ajouter le réseau dans le modèle
		resource.getContents().add(petri);
		
		//Table de hachage liant nom de la ressource et place de la ressource du réseau de petri
		HashMap<String,Place> liste_place = new HashMap<String,Place>();
		HashMap<String,Noeud> liste_noeud = new HashMap<String,Noeud>();
		
		for (Object o : process.getProcessElements()) {
			if (o instanceof Ressource) {
				Ressource r = (Ressource) o;
				//Creer une place
				Place ress = myFactory.createPlace();
				String nom_r = r.getName();
				ress.setName(nom_r);
				ress.setNbJeton(r.getQuantiteTotale());
				petri.getNoeud().add(ress);
				liste_place.put(nom_r, ress);
				}
			}
		
		
		for (Object o : process.getProcessElements()) {
			if (o instanceof WorkDefinition) {
				WorkDefinition wd = (WorkDefinition) o;
				String name = wd.getName();
				
				//Place _ready
				Place ready = myFactory.createPlace();
				ready.setName(name + "_ready");
				ready.setNbJeton(1);
			    petri.getNoeud().add(ready);
			    Arc arc1 = myFactory.createArc();
			    arc1.setSource(ready);
				
				//Transition _start
				Transition start = myFactory.createTransition();
				start.setName(name + "_start");
				petri.getNoeud().add(start);
				arc1.setCible(start);
				Arc arc2 = myFactory.createArc();
			    arc2.setSource(start);
			    Arc arc3 = myFactory.createArc();
			    arc3.setSource(start);
				
				//Place _running
				Place running = myFactory.createPlace();
				running.setName(name + "_running");
				running.setNbJeton(0);
			    petri.getNoeud().add(running);
				arc2.setCible(running);
				Arc arc4 = myFactory.createArc();
			    arc4.setSource(running);
			    
				//Place _started
				Place started = myFactory.createPlace();
				started.setName(name + "_started");
				started.setNbJeton(0);
			    petri.getNoeud().add(started);
				arc3.setCible(started);
	
			    
				//Transition _finish
				Transition finish = myFactory.createTransition();
				finish.setName(name + "_finish");
				petri.getNoeud().add(finish);
				arc4.setCible(finish);
				Arc arc5 = myFactory.createArc();
			    arc5.setSource(finish);
				
				//Place _finished
				Place finished = myFactory.createPlace();
				finished.setName(name + "_finished");
				finished.setNbJeton(0);
			    petri.getNoeud().add(finished);
				arc5.setCible(finished);
				
				//Ajouter les arcs
				arc1.setPoids(1);
				arc2.setPoids(1);
				arc3.setPoids(1);
				arc4.setPoids(1);
				arc5.setPoids(1);
				petri.getTransition().add(arc1);
				petri.getTransition().add(arc2);
				petri.getTransition().add(arc3);
				petri.getTransition().add(arc4);
				petri.getTransition().add(arc5);
				
				//Ressources
				for (RessourceUtile ru: wd.getRessourceutile()) {
					Ressource r = ru.getRessource();
					int poids = ru.getQuantiteRequise();
					Arc arc_ressource_debut = myFactory.createArc();
					Place place_r = liste_place.getOrDefault(r.getName(), null);
					arc_ressource_debut.setSource(place_r);
					arc_ressource_debut.setCible(start);
					arc_ressource_debut.setPoids(poids);
					Arc arc_ressource_fin = myFactory.createArc();
					arc_ressource_fin.setSource(finish);
					arc_ressource_fin.setCible(place_r);
					arc_ressource_fin.setPoids(poids);
					petri.getTransition().add(arc_ressource_debut);
					petri.getTransition().add(arc_ressource_fin);
				}
				
				//Ajout à la table de hashage
				liste_noeud.put(name + "_start", start);
				liste_noeud.put(name + "_started", started);
				liste_noeud.put(name + "_finish", finish);
				liste_noeud.put(name + "_finished", finished);
			}
			
		}
		for (Object o : process.getProcessElements()) {
			if (o instanceof WorkSequence) {
				WorkSequence ws = (WorkSequence) o;
				String nom_source = ws.getPredecessor().getName();
				String nom_cible = ws.getSuccessor().getName();
				ReadArc arc_ws = myFactory.createReadArc();
				switch (ws.getLinkType()) {
				case START_TO_START:
					Place source = (Place) liste_noeud.getOrDefault(nom_source + "_started", null);
					Transition cible = (Transition) liste_noeud.getOrDefault(nom_cible + "_start", null);
					arc_ws.setCible(cible);
					arc_ws.setSource(source);
					arc_ws.setPoids(1);
					break;
				case START_TO_FINISH:
					Place source1 = (Place) liste_noeud.getOrDefault(nom_source + "_started", null);
					Transition cible1 = (Transition) liste_noeud.getOrDefault(nom_cible + "_finish", null);
					arc_ws.setCible(cible1);
					arc_ws.setSource(source1);
					arc_ws.setPoids(1);
					break;
				case FINISH_TO_START:
					Place source2 = (Place) liste_noeud.getOrDefault(nom_source + "_finished", null);
					Transition cible2 = (Transition) liste_noeud.getOrDefault(nom_cible + "_start", null);
					arc_ws.setCible(cible2);
					arc_ws.setSource(source2);
					arc_ws.setPoids(1);
					break;
				case FINISH_TO_FINISH:
					Place source3 = (Place) liste_noeud.getOrDefault(nom_source + "_finished", null);
					Transition cible3 = (Transition) liste_noeud.getOrDefault(nom_cible + "_finish", null);
					arc_ws.setCible(cible3);
					arc_ws.setSource(source3);
					arc_ws.setPoids(1);
					break;
				}
				petri.getTransition().add(arc_ws);
				}
			}
		// Sauver la ressource
	    try {
	    	resource.save(Collections.EMPTY_MAP);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}

