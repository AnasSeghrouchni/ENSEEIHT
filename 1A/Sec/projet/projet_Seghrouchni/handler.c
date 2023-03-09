#include <stdio.h>  /* entrées/sorties */
#include <unistd.h> /* primitives de base : fork, ...*/
#include <stdlib.h> /* exit */
#include <sys/wait.h>
#include <signal.h>
#include <string.h>
#include "readcmd.h"
#include "job.h"
#include "handler.h"

extern int pid_fils;
extern int etat_fils;
extern lca jobs;
extern cmdline *cmd;
extern int avant_plan;

void handler_sigchld(int signal)
{
    do
    {
        pid_fils = waitpid(-1, &etat_fils, WUNTRACED | WCONTINUED | WNOHANG);
        if (pid_fils > 0)
        {
                job *j = chercher_job_pid(pid_fils, &jobs);
                
                if (j != NULL)
                {
                    if (WIFSTOPPED(etat_fils))
                    {
                        if (pid_fils == avant_plan)
                        {
                            avant_plan = 0;
                        };
                        j->etat = "Suspendu";
                    }
                    else if (WIFCONTINUED(etat_fils))
                    {
                        j->etat = "Actif";
                    }
                    else if (WIFEXITED(etat_fils) || WIFSIGNALED(etat_fils))
                    {   
                        if (pid_fils == avant_plan)
                        {
                            avant_plan = 0;
                        };
                        supprimer(j->pid, &jobs);
                    
                }
            }
        }
    } while (pid_fils > 0);
}


void handler_sigtstp(int signal){
       if (avant_plan){
        kill(pid_fils,SIGSTOP);
        printf("\n");
        }
        else {}
}

void handler_sigint(int signal){
        if (avant_plan){
        kill(pid_fils,SIGKILL);
        printf("\n");
        }
        else {}
}