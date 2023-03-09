#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/wait.h> /* wait */

void garnir(char zone[], int lg, char motif) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		zone[ind] = motif ;
	}
}

void lister(char zone[], int lg) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		printf("%c",zone[ind]);
	}
	printf("\n");
}

int main(int argc,char *argv[]) {
	int taillepage = sysconf(_SC_PAGESIZE);
	int fichier = open("fichier_a", O_CREAT | O_RDWR | O_TRUNC , 0777);
	for (int i = 0 ; i<3*taillepage ; i++){
		write(fichier, "a", sizeof(char));
	};
	char* base = mmap (NULL, 3*taillepage, PROT_WRITE | PROT_READ, MAP_SHARED,  fichier, 0);
	if (base == MAP_FAILED) 
	{
		printf ("mmap failed \n"); 
		exit(1);
	}
	int pid_fils = fork();
	if(pid_fils == 0){
		char* base_fils = mmap (NULL, 3*taillepage, PROT_WRITE | PROT_READ, MAP_PRIVATE,  fichier, 0);
		if (base_fils == MAP_FAILED) 
		{
		printf ("mmap failed \n"); 
		exit(1);
		}
		lister(base_fils ,10);
		sleep(4);
		lister(base_fils ,10);
		lister(base_fils + taillepage,10);
		lister(base_fils + 2*taillepage ,10);
		garnir(base_fils+taillepage,taillepage,'d');
		sleep(8);

		exit(1);
	}
	else{
		sleep(1);
		garnir(base,2*taillepage,'b');
		sleep(6);
		garnir(base+taillepage, taillepage, 'c');
		waitpid(pid_fils,NULL,0);
		lister(base ,10);
		lister(base + taillepage,10);
		lister(base + 2*taillepage ,10);
	}
	close(fichier);
	}

	


