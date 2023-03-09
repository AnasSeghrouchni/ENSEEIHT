#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

// Definition du type t_note
struct t_note {
        float notee;
        float coeff;
};

// Definition d'un tableau de notes t_tab_notes de 5 éléments.
typedef struct t_note t_tab_notes[5];

/**
 * \brief Initialiser une note
 * \param[out] note note à initialiser
 * \param[in] valeur nombre de points
 * \param[in] coef coefficient
 * \pre valeur <= 20 && valeur >= 0
 * \pre coef <= 1 && coef >= 0
 */ 
void initialiser_note(struct t_note note, float valeur, float coef){
    assert(valeur <= 20 && valeur >= 0);
    assert(coef <= 20 && coef >= 0);
    note.notee=valeur;
    note.coeff=coef;
}


/**
 * \brief Calculer la moyenne des notes du tableau 
 * \param[in] tab_notes tableau de nodes
 * \param[in] nb_notes nombre de notes
 */ 
float moyenne(t_tab_notes tab_not, int nb_notes){
    float moy=0;
    int i;
    for (i=0;i<nb_notes;i+=1){
        float y= tab_not[i].notee;
        float v=tab_not[i].coeff;
        
        moy+=y*v;
    }
    return moy;
}


int main(void){
    t_tab_notes notes;
    struct t_note not;
    initialiser_note(not,10,0.2);
    
    //Initialiser les éléments d'une variable tableau à 0.0
    initialiser_note(notes[0], 10, 0.2);
    initialiser_note(notes[1], 1.5, 0.3);
    initialiser_note(notes[2], 12, 0.5);
    
    
    //Calculer la moyenne des 3 notes
    float moy = moyenne(notes, 3);
    printf("%f",moy);
    assert( (int)(moy*100) == (int)((10*0.2 + 1*0.3 + 12*0.5)*100));
    return EXIT_SUCCESS;
}
