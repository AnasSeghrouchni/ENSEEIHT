#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "job.h"

void initialiser(lca *lca)
{
    *lca = NULL;
}

void detruire(lca *lca)
{
    job *aliberer;
    job *temporaire = *lca;
    while (temporaire != NULL)
    {
        aliberer = temporaire;
        temporaire = temporaire->suivant;
        free(aliberer);
    }
    *lca = NULL;
}

void ajouter(int pid, job **lca, char **seq)
{
    job *ajouter = malloc(sizeof(job));
    char *cmd = malloc(sizeof(char) * 256);
    // copie seq dans cmd
    while (*seq)
    {
        strcat(cmd, *seq);
        seq++;
        strcat(cmd, " ");
    }
    ajouter->cmd = cmd;
    ajouter->pid = pid;
    ajouter->etat = "Actif";
    ajouter->suivant = NULL;
    job *temporaire = *lca;
    if (temporaire == NULL)
    {
        ajouter->id = 1;
        *lca = ajouter;
    }
    else
    {
        ajouter->id = 1;
        if (temporaire->id > 1)
        {
            ajouter->suivant = temporaire;
            *lca = ajouter;
        }
        else
        {
            while (temporaire->suivant != NULL && temporaire->suivant->id >= ajouter->id)
            {
                ajouter->id += 1;
                temporaire = temporaire->suivant;
            }
            if (temporaire->suivant != NULL)
            {
                ajouter->suivant = temporaire;
                temporaire = ajouter;
            }
            else
            {
                ajouter->id += 1;
                temporaire->suivant = ajouter;
            }
        }
    }
}

void supprimer(int pid, job **lca)
{
    job *temporaire = *lca;
    job *precedent = NULL;
    if (temporaire->pid == pid)
    {
        *lca = temporaire->suivant;
        free(temporaire);
    }
    else
    {
        while (temporaire != NULL && temporaire->pid != pid)
        {
            precedent = temporaire;
            temporaire = temporaire->suivant;
        }
        if (temporaire == NULL)
        {
            return;
        }
        else
        {
            precedent->suivant = temporaire->suivant;
            free(temporaire);
        }
    }
}

void afficher(job **lca)
{
    job *temporaire = *lca;
    if (temporaire == NULL)
    {
        printf("Aucun job en cours\n");
    }
    while (temporaire)
    {

        printf("id: %d, pid: %d, état: %s, cmd: %s\n", temporaire->id, temporaire->pid, temporaire->etat, temporaire->cmd);
        temporaire = temporaire->suivant;
    }
}

job *chercher_job_id(int id, lca *lca)
{
    job *temporaire = *lca;
    while (temporaire != NULL)
    {
        if (temporaire->id == id)
        {
            return temporaire;
            break;
        }
        temporaire = temporaire->suivant;
    }
    return NULL; // On a bouclé sans trouvé id
}

job *chercher_job_pid(int pid, lca *lca)
{
    job *temporaire = *lca;
    while (temporaire != NULL)
    {
        if (temporaire->pid == pid)
        {
            return temporaire;
            break;
        }
        temporaire = temporaire->suivant;
    }
    return NULL; // On a bouclé sans trouvé id
}