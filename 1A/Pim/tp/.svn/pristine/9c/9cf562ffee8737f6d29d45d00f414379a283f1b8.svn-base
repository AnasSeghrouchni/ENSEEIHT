#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>
#define MAX 5

// Definition du type monnaie
struct t_Monnaie {
float Valeur;
char Devise;
};

/**
 * \brief Initialiser une monnaie 
 * \param[out] Monnaie Pointeur sur T_Monnaie à initialiser
 * \param[in] Val Valeur de la monnaie
 * \param[in] Dev Devise de la monnaie
 * \pre Valeur>0
 * \
 */ 
void initialiser(struct t_Monnaie* Monnaie, float Val, char Dev ){
    assert(Val>0);
    Monnaie->Valeur=Val;
    Monnaie->Devise=Dev;
}


/**
 * \brief Ajouter une monnaie m2 à une monnaie m1 
 * \param[in out]m2 Monnaie à ajouter qui est changé
 * \param[in]m1 Monnaie à ajouter qui est inchangé
 */ 
bool ajouter(struct t_Monnaie m1,struct t_Monnaie* m2){
    if (m1.Devise==m2->Devise) {
    m2->Valeur+=m1.Valeur;
    return true;}
    else {return false;};
}


/**
 * \brief Tester Initialiser 
 * \param[]
 */

void tester_initialiser(){
    struct t_Monnaie m;
    initialiser(&m,2.0,'e');
    assert(m.Valeur==3.0);
    assert(m.Devise=='e');
    printf("Initialiser ok");
}

/**
 * \brief Tester Ajouter 
 * \param[]
 * 
 */ 
void tester_ajouter(){
    struct t_Monnaie m1,m2,m3;
    initialiser(&m1,7.0,'$');
    initialiser(&m2,10.0,'$');
    initialiser(&m3,1000.0,'o');
    assert(ajouter(m1,&m2));
    assert(m2.Valeur==17.0);
    assert(!ajouter(m2,&m3));
}



int main(void){
    // Un tableau de 5 monnaies
    struct t_Monnaie tab[MAX];

    //Initialiser les monnaies
    int i;
    for (i=0;i<MAX;i++) {
    float Val;
    char D;
    char inutile;
    printf("Rentrez une valeur puis une devise (en laissant un espace) :");
    scanf("%f",&Val);
    scanf("%c",&inutile);
    scanf("%c",&D);
    initialiser(&tab[i],Val,D);
        };
    // Afficher la somme des toutes les monnaies qui sont dans une devise entrée par l'utilisateur.
    char dev;
    printf("Rentrez la devise dont vous voulez calculer la somme : ");
    scanf(" %c",&dev);
    float somme=0.0;
    for (i=0;i<MAX;i++) {
    if (tab[i].Devise==dev) {
    somme+=tab[i].Valeur;
    }
    };
    printf("Vous avez %1.2f %c dans votre tableau\n",somme,dev);
    return EXIT_SUCCESS;
}
