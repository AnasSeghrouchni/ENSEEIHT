#ifndef __HANDLER_H
#define __HANDLER_H

typedef struct cmdline cmdline;

/**
 * @brief handler du signal sig_chdl
 *
 * @param signal le signal sig_chdl
 */
void handler_sigchld(int signal);

/**
 * @brief handler du signal sig_tstp
 * 
 * @param signal le signal SIGTSTP
 */
void handler_sigtstp(int signal);

/**
 * @brief handler du signal sigint
 * 
 * @param signal le signal SIGINT
 */
void handler_sigint(int signal);

#endif
