#ifndef __JOB_H
#define __JOB_H

typedef struct job
{
    int id;              // identifiant propre au shell
    int pid;             // pid
    char *etat;          // actif(A) ou suspendu(S)
    char *cmd;           // la commande lancée
    struct job *suivant; // pointeur sur le job suivant
} job;

typedef struct job job;
typedef job *lca;

/**
 * @brief Initialise une lca de jobs
 *
 * @param lca la lca a inisialiser.
 */
void initialiser(lca *lca);

/**
 * @brief libère une lca
 *
 * @param lca la lca a liberer
 */
void detruire(lca *lca);

/**
 * @brief ajoute un job à la lca
 *
 * @param pid pid du job a ajouter
 * @param lca lca a mettre a jour
 * @param seq cmd rentrée par l'utilisateur
 */
void ajouter(int pid, job **lca, char **seq);

/**
 * @brief Supprime un job via son identifiant du minishell
 *
 * @param id identifiant du minishell
 * @param lca lca à mettre à jour
 */
void supprimer(int id, job **lca);

/**
 * @brief affiche une lca (commande lj)
 *
 * @param lca
 */
void afficher(job **lca);

/**
 * @brief cherche un job via son pid
 *
 * @param id identifiant minishell
 * @param lca liste de job
 * @return job* le job trouvé (NULL si introuvable)
 */
job *chercher_job_id(int id, lca *lca); // chercher le job associé à un id

/**
 * @brief cherche un job via son identifiany minishell
 *
 * @param pid pid
 * @param lca liste de job
 * @return job* le job trouvé (NULL si introuvable)
 */
job *chercher_job_pid(int pid, lca *lca); // chercher le job associé à un pid

#endif
