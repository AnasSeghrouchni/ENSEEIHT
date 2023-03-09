#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <string.h>

int main(int argc, char *argv[])
{

    int codeterm;
    int pid;
    char buf[30];           /* contient la commande saisie au clavier */
    int ret;               /* valeur de retour de scanf */
    printf(">>>");
    ret = scanf("%s", buf); /* lit et range dans buf la chaine entrée au clavier */
    while (ret != EOF && strcmp(buf,"exit"))
    {
        pid = fork();
        if (pid == 0)
        {
            execlp(buf, buf,NULL);
            exit(EXIT_FAILURE);
        }
        wait(&codeterm);
        if (!WEXITSTATUS(codeterm))
        {
            printf("SUCCES\n");
        }
        else
        {
            printf("ECHEC\n");
        }
        printf(">>>");
        ret = scanf("%s", buf); 
    }
    printf("\nSalut\n");
    return 0;
}