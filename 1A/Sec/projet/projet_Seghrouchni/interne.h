#ifndef __INTERNE_H
#define __INTERNE_H

typedef struct cmdline cmdline;

/**
 * @brief Gere les fonctions internes du minishell
 *
 * @param cmd la cmd rentrée
 * @param jobs une lca de jobs
 * @param chemin le chemin initiale du minishell pour la commande cd sans argument
 * @return int 0 : exit
 *             1 : continue
 *             2 : la commande n'est pas interne
 */
int interne(cmdline *cmd, lca jobs, char *chemin);

#endif