/** Squelette du programme **/
/*********************************************************************
 *  Auteur  : Anas Seghrouchni
 *  Version : 
 *  Objectif : Conversion pouces/centimètres
 ********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#define UN_POUCE 2.54

int main()
{
    float valeur;
    char unite;
    float lg_p=0.0;
    float lg_cm=0;
    char inutile;
    printf("Entrer une longueur (valeur + unité) : ");
    scanf("%f", &valeur);
    scanf("%c",&inutile);
    scanf("%c", &unite);
    switch (unite) {
        case 'p': 
            lg_p += valeur;
            lg_cm += lg_p * UN_POUCE;
            break;
        case 'P': 
            lg_p += valeur;
            lg_cm += lg_p * UN_POUCE;
            break;
        case 'c' : 
            lg_cm += valeur;
            lg_p += lg_cm / UN_POUCE;
            break;
        case 'C' : 
            lg_cm += valeur;
            lg_p += lg_cm / UN_POUCE;
            break;
        case 'm':
            lg_cm += valeur*100;
            lg_p += lg_cm / UN_POUCE;
            break;
        case 'M':
            lg_cm += valeur*100;
            lg_p += lg_cm / UN_POUCE;
            break;
        default :
            lg_p+=0;
            lg_cm+=0;
            break;
    }
    printf ("%f p = %f cm",lg_p,lg_cm);

    return EXIT_SUCCESS;
}
 
