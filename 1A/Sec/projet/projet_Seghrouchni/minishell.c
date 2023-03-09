#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include "job.h"
#include "handler.h"
#include "interne.h"
#include "readcmd.h"

typedef struct cmdline cmdline;

// variables globales
cmdline *cmd;
int pid_fils;
int etat_fils;
lca jobs;
int in;
int avant_plan = 0;
struct sigaction action;
int fichier_in,fichier_out;

/* Exécuter une commande contenant un ou plusieurs pipes 
parametres :
IN : cmdv = ligne de commande (cmdv[0] | cmdv[1] ... )
La commande peut etre sans pipe
*/
void exec_cmd_pipe(char **cmdv[]) {
    int ret, pid_sous_fils, pf2p[2];
    int nbCmd;

    /* Trouver s'il y a un pipe */
	  nbCmd = 0;
    while (cmdv[nbCmd] != NULL) { 
        nbCmd++; 
    }
   
    if (nbCmd > 1) { /* c'est une commande avec 1 pipe ou + : cmdv[0] | cmdv[1] ...*/
		
        ret = pipe(pf2p);
        if (ret == -1) {  
        printf("Erreur pipe\n");
        exit(1);
        }
        /* Creer un fils pour exécuter cmdv[0], le père executant cmdv[1] ... */
        pid_sous_fils = fork();
        switch (pid_sous_fils) {
            case -1 :
              printf("Erreur fork du sous fils\n"); 
				      exit(1);
  
            case 0 : /*fils execute cmdv[0] et doit transmettre le résultat au père */
              close(pf2p[0]);
              dup2(pf2p[1], 1);
              ret = execvp(cmdv[0][0], cmdv[0]);
              printf("Erreur execvp sous fils\n");  /* seulement si execvp echoue */
              exit(ret);

            default : /* pere execute cmdv[1] | ... en récupérant le flot de données 
						fourni par son fils, qui servira d'entrée pour cmdv[1]*/
            close(pf2p[1]);
            dup2(pf2p[0],0);
				    exec_cmd_pipe ( cmdv + 1 );
        }
    }
    else {  /* dernière commande : sans pipe */
        ret = execvp(cmdv[0][0], cmdv[0]);
        printf("Erreur execvp dernière commande\n");  /* seulement si execvp echoue */
        exit(ret);
    }
    return;
}

/**
 * @brief execute une commande soit en creant un fils soit directement par le père.
 * 
 * @param cmdv la commande à executer
 */
void executer(cmdline *cmdv){

      pid_fils = fork();
      if (pid_fils < 0)
      {
        printf("ERROR: fork a échoué\n");
        exit(EXIT_FAILURE);
      }
      if (pid_fils == 0)
      {
        
        action.sa_handler = SIG_IGN;
        sigaction(SIGTSTP, &action, NULL); // on ignore SIGTSTP
        sigaction(SIGINT, &action, NULL);  // on ignore SIGINT
       
        if (cmdv->in)
          {
            fichier_in = open(cmd->in, O_RDONLY);
            dup2(fichier_in, 0);
          }
        if (cmdv->out)
          {
              fichier_out = open(cmdv->out, O_CREAT | O_TRUNC | O_WRONLY, 0640);
              dup2(fichier_out, 1);
          }
          exec_cmd_pipe(cmdv->seq); 
          exit(EXIT_FAILURE);

      }
      else if (pid_fils > 0)
      {
        
        if (!cmdv->backgrounded)
        {    
          ajouter(pid_fils, &jobs, *(cmdv->seq));
          avant_plan = pid_fils;
          while (avant_plan)
          {
            pause();
          }
        }
        else
        {
          ajouter(pid_fils, &jobs, *(cmdv->seq));
        }
      }
}



int main(int argc, char *argv[])
{
  // signaux
  signal(SIGCHLD, handler_sigchld);
  sigemptyset(&action.sa_mask);
  action.sa_flags = SA_SIGINFO | SA_RESTART;
  action.sa_handler = handler_sigchld;
  sigaction(SIGCHLD, &action, NULL);
  action.sa_handler = handler_sigint;
  sigaction(SIGINT, &action, NULL);
  action.sa_handler = handler_sigtstp;
  sigaction(SIGTSTP, &action, NULL);
  
  // initialiser la liste jobs
  initialiser(&jobs);

  // récuperer le chemin initial
  char chemin[256];
  getcwd(chemin, sizeof(chemin));

  // boucle
  while (1)
  {
    printf(">>>");
    // lecture de la commande
    cmd = readcmd();
    // interne
    in = interne(cmd, jobs, chemin);
    if (in == 0)
    {
      break;
    }
    else if (in == 1)
    {
      continue;
    }
    else
    {
    executer(cmd);
    }
  }
  detruire(&jobs);
}