#include <stdio.h>    /* entrées sorties */
#include <unistd.h>   /* pimitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <sys/wait.h> /* wait */
#include <string.h>   /* opérations sur les chaines */
#include <fcntl.h>    /* opérations sur les fichiers */

#define BUFSIZE 32


int main(int argc, char *argv[])
    {
        if (argc!=3){
            printf("Veuillez rentrer 3 arguments");
            exit(1);
        } else {
        int desc_source,desc_dest,lus;

        char buffer[BUFSIZE] ;     /* buffer de lecture */

        /* ouverture du fichier source en lecture */
        desc_source=open(argv[1],O_RDONLY);
        perror("Ouverture du fichier source ");

        /*ouverture du fichier destination */
        desc_dest=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0640);
        perror("Creation du fichier destination ");

        do{
            lus=read(desc_source, buffer,BUFSIZE);
            write(desc_dest,buffer,lus);
        } while (lus>0);
        /*Fermeture des fichiers */
        close(desc_dest);
        close(desc_source);
    }
    }
