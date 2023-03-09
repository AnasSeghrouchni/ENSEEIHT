#include <stdio.h>    /* entrées/sorties */
#include <unistd.h>   /* primitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <signal.h>

#define MAX_PAUSES 10     /* nombre d'attentes maximum */

void handler(int S){
    printf("pid = %d - Signal = %d\n", getpid(),S);
}

int main(int argc, char *argv[]) {
	int nbPauses;
    int pid;

    for(int i=1; i<=SIGRTMAX;i++){
        signal(i,handler);
    }

	pid =fork();
    if (pid == 0){
       for (int j=0;j<100;j++){
           sleep(1);
       }
    }
    else{
	nbPauses = 0;
	printf("Processus de pid %d\n", getpid());
	for (nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses++) {
		pause();		// Attente d'un signal
		printf("pid = %d - NbPauses = %d\n", getpid(), nbPauses);
    } ;
    }
    return EXIT_SUCCESS;
}