#include <stdio.h>  /* entrées/sorties */
#include <unistd.h> /* primitives de base : fork, ...*/
#include <stdlib.h> /* exit */
#include <sys/wait.h>
#include <signal.h>
#include <string.h>
#include "job.h"
#include "interne.h"
#include "readcmd.h"

extern int avant_plan;

// traiter les commandes internes
int interne(cmdline *cmd, lca jobs, char *chemin)
{
  job *j;
  if (cmd == NULL || cmd->seq[0] == NULL)
  {
    return 1;
  }
  else if (!strcmp(cmd->seq[0][0], "exit"))
  {
    return 0;
  }
  else if (!strcmp(cmd->seq[0][0], "cd"))
  {
    int boolcd = 0;
    if (cmd->seq[0][1] == NULL)
    {
      boolcd = chdir(chemin);
    }
    else
    {
      boolcd = chdir(cmd->seq[0][1]);
    }
    if (boolcd)
    {
      printf("ERROR: cd a échoué\n");
    }
    return 1;
  }
  else if (!strcmp(cmd->seq[0][0], "lj"))
  {
    afficher(&jobs);
    return 1;
  }
  else if (!strcmp(cmd->seq[0][0], "sj"))
  {
    if (cmd->seq[0][1] == NULL)
    {
      printf("ERROR: il manque l'id\n");
      return 1;
    }
    else
    {
      j = chercher_job_id(atoi(cmd->seq[0][1]), &jobs);
      if (j != NULL)
      {
        kill(j->pid, SIGSTOP);
      }
      else
      {
        printf("ERROR: id inconnu\n");
      }
      return 1;
    }
  }
  else if (!strcmp(cmd->seq[0][0], "bg"))
  {
    if (cmd->seq[0][1] == NULL)
    {
      printf("ERROR: il manque l'id\n");
      return 1;
    }
    else
    {
      j = chercher_job_id(atoi(cmd->seq[0][1]), &jobs);
    }
    if (j != NULL)
    {
      kill(j->pid, SIGCONT);
    }
    else
    {
      printf("ERROR: id inconnu\n");
    }
    return 1;
  }
  else if (!strcmp(cmd->seq[0][0], "fg"))
  {
    if (cmd->seq[0][1] == NULL)
    {
      printf("ERROR: il manque l'id\n");
      return 1;
    }
    else
    {
      j = chercher_job_id(atoi(cmd->seq[0][1]), &jobs);
    }
    if (j != NULL)
    {
      kill(j->pid, SIGCONT);
      avant_plan=j->pid;
      while(avant_plan){
        pause();
      }
    }
    else
    {
      printf("ERROR: id inconnu\n");
    }
    return 1;
  }
  else if (!strcmp(cmd->seq[0][0], "susp"))
  {
    kill(getpid(),SIGSTOP);
  }
  
  return 2;
}