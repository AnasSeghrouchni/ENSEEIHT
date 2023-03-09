/* Exemple d'illustration des primitives Unix : Un père et ses fils */
/* Création de fils : fork et exit */

#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <string.h>   /* manipulation des chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define NB_FILS 3     /* nombre de fils */

int main(int argc, char *argv[])
{
    int  retour,desc;
    int duree_sommeil = 1;
    
    retour = fork();
    desc=open("test.txt",O_WRONLY|O_CREAT|O_TRUNC,0640);
        /* Bonne pratique : tester systématiquement le retour des appels système */
        if (retour < 0) {   /* échec du fork */
            printf("Erreur fork\n");
            /* Convention : s'arrêter avec une valeur > 0 en cas d'erreur */
            exit(1);
        }
        /* fils */
        if (retour == 0) {
            for(int i=1;i<10;i++){
            dprintf(desc,"FILS\n");
            sleep(duree_sommeil);
            }
        }
        /* pere */
        else {
            for(int i=1;i<10;i++){
            dprintf(desc,"PERE\n");
            sleep(duree_sommeil);
            }
        }
    sleep(duree_sommeil + 1);
    return EXIT_SUCCESS;
}