clear all;
format long;

%%%%%%%%%%%%
% PARAMÈTRES
%%%%%%%%%%%%

A=[0 -1 0;-1 0 0; 1 1 1];

% méthode de calcul
v = 13; 
% nombre maximum de couples propres calculés
m = 3;
percentage = 0.4;

% on génère la matrice (1) ou on lit dans un fichier (0)
genere = 0;

% méthode de calcul
v = 13; % power

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;
[ W, V, n_ev] = power_v13( A, m, percentage, eps, maxit );

