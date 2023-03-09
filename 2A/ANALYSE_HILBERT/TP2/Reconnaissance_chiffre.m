% Ce programme est le script principal permettant d'illustrer
% un algorithme de reconnaissance de chiffres.

% Nettoyage de l'espace de travail
clear all; close all;

% Repertories contenant les donnees et leurs lectures
addpath('Data');
addpath('Utils')

rng('shuffle')


% Bruit
sig0=0.2;

%tableau des csores de classification
% intialisation aléatoire pour affichage
r=rand(6,5);
r2=rand(6,5);

for k=1:5
% Definition des donnees
file=['D' num2str(k)]

% Recuperation des donnees
disp('Generation de la base de donnees');
sD=load(file);
D=sD.(file);
%

% Bruitage des données
Db= D+sig0*randn(size(D));


%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des donnees 
%%%%%%%%%%%%%%%%%%%%%%%
disp('PCA : calcul du sous-espace');
%%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
m = size(Db, 1);
n = size(Db, 2);
xbarre = mean(Db,2);
Dbc = zeros(m,n);
for i = 1:n
    Dbc(:,i) = Db(:,i) - xbarre;
end
cov = (1/n).*(Dbc*(Dbc'));
[U, Diag] = eig(cov);
vp = diag(Diag);
[D_sorted, I] = sort(vp, 'descend');
vp = vp(I);
U = U(:,I);

prec = 0,3;
l=1;
while (prec >= (1 - sqrt(vp(l)/vp(1))) && l<=m)
    l = l+1;
end
U = U(:,1:l);


%%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

disp('kernel PCA : calcul du sous-espace');
%%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
K = Db*Db';
phibarre = mean(K,2);
Kc = K;
for i = 1:n
    Kc(:,i) = K(:,i) - phibarre;
end

rg = rank(Kc);

[V, O] = eig(Kc);
[O, I] = sort(O, 'descend');
V = V(:,I);
ki=1;
while (prec >= (1 - sqrt(O(k)/O(1))) && ki<=m)
    ki = ki+1;
end

ki = min(ki,rg);
O = O(1:ki);
V = V(:,1:ki);
alpha = zeros(m,ki);
for i = 1:ki
    alpha(:,i) = (1/sqrt(O(i)))*V(:,i);
end
%%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reconnaissance de chiffres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Lecture des chiffres à reconnaitre
 disp('test des chiffres :');
 tes(:,1) = importerIm('test1.jpg',1,1,16,16);
 tes(:,2) = importerIm('test2.jpg',1,1,16,16);
 tes(:,3) = importerIm('test3.jpg',1,1,16,16);
 tes(:,4) = importerIm('test4.jpg',1,1,16,16);
 tes(:,5) = importerIm('test5.jpg',1,1,16,16);
 tes(:,6) = importerIm('test9.jpg',1,1,16,16);


 for tests=1:6
    % Bruitage
    tes(:,tests)=tes(:,tests)+sig0*randn(length(tes(:,tests)),1);
    
    % Classification depuis ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('PCA : classification');
     testc = tes(:,tests) - xbarre;
     di = norm((eye(m) - (U*(U')))*testc)/norm(testc);
     r(tests,k)  = di;
    
     if(tests==k)
       figure(100+k)
       subplot(1,2,1); 
       imshow(reshape(tes(:,tests),[16,16]));
       subplot(1,2,2);
     end  
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%
  
   % Classification depuis kernel ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('kernel PCA : classification');
     for i = 1:m
         yi = 0;
         for j = 1:m
             yi = yi +alpha(i,j)*fk(testc,Db(:,j));
         end
         pi = 0;
         for j = 1:m
             s = 0;
             for p = 1:k
                 s = s + fk(Db(:,p),Db(:,j));
             end
            pi = pi + alpha(i,j)*s;
         end
        proj = proj;
     end
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%    
 end
 
end


% Affichage du résultat de l'analyse par PCA
couleur = hsv(6);

figure(11)
for tests=1:6
     hold on
     plot(1:5, r(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r(tests,i):(r(tests,i+1)-r(tests,i))/10:r(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r(tests,5),num2str(testa));
     hold off
 end

% Affichage du résultat de l'analyse par kernel PCA
figure(12)
for tests=1:6
     hold on
     plot(1:5, r2(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r2(tests,i):(r2(tests,i+1)-r2(tests,i))/10:r2(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r2(tests,5),num2str(testa));
     hold off
 end
