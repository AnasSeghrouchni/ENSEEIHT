#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define BUFSIZE 32


int main(int argc, char *argv[]){

    /*Descripteurs des fichiers des 2 fils*/
    int desc_fils, desc_fils_2,fils,entier,retour,lu,lus;

    for (fils = 1; fils <= 2; fils++) {
        retour = fork();

        if (retour < 0) {   /* échec du fork */
            printf("Erreur fork\n");
            /* Convention : s'arrêter avec une valeur > 0 en cas d'erreur */
            exit(1);
        }

        if (fils==1){
            /*Ouverture du fichier temp*/
            desc_fils=open("temp",O_WRONLY|O_CREAT|O_TRUNC,0640);
            
            /*Ecriture des entiers*/
            for(entier=1;entier<=30;entier++) {
                if(entier % 10==0){
                    lseek(desc_fils,0,SEEK_SET);
                }
                write(desc_fils,entier,sizeof(int));
                sleep(1);
            }
        }
        else if(fils==2){
            lus=read(desc_fils,lu,sizeof(int));
            printf(lus);

        }
        }



}