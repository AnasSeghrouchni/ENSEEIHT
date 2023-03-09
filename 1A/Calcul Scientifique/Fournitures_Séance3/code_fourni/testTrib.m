clear;
close all;

load eigenfaces_part3.mat;

% Tirage aleatoire d'une image de test :
%personne = randi(nb_personnes);
%posture = randi(nb_postures);
% si on veut tester/mettre au point, on fixe l'individu
personne = 10
posture = 9

ficF = strcat('./Data/', liste_personnes{personne}, liste_postures{posture}, '-300x400.gif');
img = imread(ficF);
image_test = double(transpose(img(:)));
 

% Pourcentage d'information 
per = 0.95;

% Nombre N de composantes principales a prendre en compte 
% [dans un second temps, N peut etre calcule pour atteindre le pourcentage
% d'information avec N valeurs propres (contraste)] :
N = 8;

% N premieres composantes principales des images d'apprentissage :
C = (X_centre*W)';
Data_A = C(1:N,:);

% N premieres composantes principales de l'image de test :

image_test_centree = image_test - individu_moyen;
Data_T = (image_test_centree * W)';
Data_T = Data_T(1:N);

% ListeClass :
ListeClass = 1:(length(liste_personnes_base)*nb_postures_base);
labelA = ListeClass;

% K plus proches voisins
K = 1;

% Determination de l'image d'apprentissage la plus proche (plus proche voisin) :

[Partition, nech] = kppv(Data_A, labelA, Data_T, 1, K, ListeClass);

individu_reconnu = Partition;

% pour l'affichage (A CHANGER)
personne_proche = mod(individu_reconnu + 1, nb_postures_base) + 1;
posture_proche = int8(individu_reconnu/nb_postures_base);

figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.8*L,0.5*H]);

subplot(1, 2, 1);
% Affichage de l'image de test :
colormap gray;
imagesc(img);
title({['Individu de test : posture ' num2str(posture) ' de ', liste_personnes{personne}]}, 'FontSize', 20);
axis image;


ficF = strcat('./Data/', liste_personnes_base{personne_proche}, liste_postures{posture_proche}, '-300x400.gif')
img = imread(ficF);
        
subplot(1, 2, 2);
imagesc(img);
title({['Individu la plus proche : posture ' num2str(posture_proche) ' de ', liste_personnes_base{personne_proche}]}, 'FontSize', 20);
axis image;