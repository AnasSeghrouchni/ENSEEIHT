clear;
close all;

load eigenfaces_part3;

% Tirage aléatoire d'une image de test :
personne = randi(nb_personnes)
posture = randi(nb_postures)
% si on veut tester/mettre au point, on fixe l'individu
%personne = 1
%posture = 6

ficF = strcat('./Data/', liste_personnes{personne}, liste_postures{posture}, '-300x400.gif')
img = imread(ficF);
image_test = double(transpose(img(:)));

% Nombre q de composantes principales à prendre en compte 
q = 1;

% dans un second temps, q peut être calculé afin d'atteindre le pourcentage
% d'information avec q valeurs propres (contraste)
% Pourcentage d'information 
per = 0.95;

% q premieres composantes principales des images d'apprentissage
Cx = X_centre*W(:,1:q);
Data_Cx = Cx(:,:);

% q premieres composantes principales des autres images
image_test_centree = image_test - individu_moyen;
Data_Test = (image_test_centree * W(:,1:q));
Data_Test = Data_Test;

%Lablel 5 ? :$
ListeClass = 1:(nb_personnes_base*nb_postures_base);
labelCx = ListeClass;

% Kppv
K=1;
[individu_suspect, nech] = kppv(Data_Cx, labelCx, Data_Test, 1, K, ListeClass);

% individu pseudo-résultat pour l'affichage (A CHANGER)
posture_proche = mod(individu_suspect +1, nb_postures_base) +1;
personne_proche = int8(individu_suspect/nb_postures_base);

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
