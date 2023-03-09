/**
 *  \author Xavier Cr�gut <nom@n7.fr>
 *  \file file.c
 *
 *  Objectif :
 *	Implantation des op�rations de la file
*/

//Bilan effectué par groupe : LAZARE Léo et SEGHROUCHNI Anas
#include <malloc.h>
#include <assert.h>

#include "file.h"


void initialiser(File *f)
{   

    f->tete=NULL;
    f->queue=NULL;
    assert(est_vide(*f));
}


void detruire(File *f)
{
    Cellule *aliberer1;
    Cellule *temporaire=f->tete;
    while(temporaire!=NULL){
        aliberer1=temporaire;
        temporaire=temporaire->suivante;
        free(aliberer1);
        aliberer1=NULL;
    }
    
}


char tete(File f)
{
    assert(! est_vide(f));
    return(f.tete->valeur);

}


bool est_vide(File f)
{
    return (f.tete==NULL && f.queue==NULL);
}

/**
 * Obtenir une nouvelle cellule allou�e dynamiquement
 * initialis�e avec la valeur et la cellule suivante pr�cis� en param�tre.
 */
static Cellule * cellule(char valeur, Cellule *suivante)
{   
    Cellule *ajouter = malloc(sizeof(Cellule));
    ajouter->suivante=suivante;
    ajouter->valeur=valeur;
    return ajouter;
}


void inserer(File *f, char v)
{   
    assert(f != NULL);
    Cellule *c=cellule(v,NULL);
    if(est_vide(*f)){
        f->tete=c;
        f->queue=c;
       // printf("\nestvide\n");
    }
    else{


    (f->queue)->suivante=c;
    (f->queue)=c;
          //  printf("\nestnonvide\n");
    }
}

void extraire(File *f, char *v)
{
    assert(f != NULL);
    assert(! est_vide(*f));
    *v=tete(*f);
    Cellule *asupp = f->tete;
    if (f->tete == f->queue)
    {
        f->queue = NULL;
    }
    f->tete=f->tete->suivante;
    free(asupp);


}


int longueur(File f)
{   
    int compteur=0;
    Cellule *temporaire = f.tete;
    while(temporaire != NULL){
        compteur++;
        temporaire=temporaire->suivante;
    }
    return compteur;
}