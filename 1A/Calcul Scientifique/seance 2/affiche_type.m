close all
figure 
load("A_100_1.mat");
plot(D);
title("Evolution des valeurs propres pour une matrice de type 1 de taille 100 ");
nexttile
load("A_100_1.mat");
plot(D);
title("Valeurs propres pour une matrice de type 1 de taille 100 ")
xlabel("Indice des vp")
ylabel("Valeur des vp")