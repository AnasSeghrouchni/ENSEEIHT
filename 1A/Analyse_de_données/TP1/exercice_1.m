clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('ishihara-0.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X = [R(:), V(:), B(:)];			% Les trois canaux sont vectorises et concatenes
Xc=(X-mean(X));

% Matrice de variance/covariance :
Sigma=(1/length(X))*(X')*X-mean(X)'*mean(X) ;

% Coefficients de correlation lineaire :

r_rv=(Sigma(2,1))/(sqrt(Sigma(1,1)*Sigma(2,2)));
r_rb=Sigma(3,1)/(sqrt(Sigma(1,1)*Sigma(3,3)));
r_bv=Sigma(3,2)/(sqrt(Sigma(3,3)*Sigma(2,2)));

% Proportions de contraste :

c_r=Sigma(1,1)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));

c_v=Sigma(2,2)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));

c_b=Sigma(3,3)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));

[W,D]=eig(Sigma);

[Vp_tri,passage]=sort(diag(D),'descend');

C=X*W;
im_r=reshape(C(:,1),size(R));
im_v=reshape(C(:,2),size(V));
im_b=reshape(C(:,3),size(B));


figure(3);
colormap gray;
subplot(2,2,2);				
imagesc(im_r);
axis off;
axis equal;
title('Canal_r','FontSize',20);


subplot(2,2,3);				
imagesc(im_v);
axis off;
axis equal;
title('Canal_v','FontSize',20);

				
subplot(2,2,4);				
imagesc(im_b);
axis off;
axis equal;
title('Canal_b','FontSize',20);
