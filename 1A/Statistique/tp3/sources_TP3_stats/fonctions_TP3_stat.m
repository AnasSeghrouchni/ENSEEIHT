
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Seghrouchni 
% Prenom : Anas
% Groupe : 1SN-F

function varargout = fonctions_TP3_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)
    A=[cos(theta)  sin(theta)];
    X=A\rho;
    x_f=X(1,1);
    y_f=X(2,1);
    rho_F=sqrt(x_f*x_f+y_f*y_f);
    theta_F=atan2(y_f,x_f);

    % A modifier lors de l'utilisation de l'algorithme RANSAC (exercice 2)
    ecart_moyen = Inf;

end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres)
k_max=parametres(3);
s_1=parametres(1);
s_2=parametres(2);
 for i= 1:k_max
     ind=randperm(length(rho),2);
     theta_i=theta(ind);
     rho_i=rho(ind);
     [rho_F,theta_F,ecart_moyen] = estimation_F(rho_i,theta_i);
     A=rho-rho_F.*cos(theta-theta_F);
     bool=abs(A)<s_1;
     nb_donnes_c=sum(bool);
         if nb_donnes_c/length(rho)>s_2
             [rho_F_estime,theta_F_estime,ecart_moyen] = estimation_F(rho(bool==1),theta(bool==1));
         end            
 end

end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
G=zeros(1,2);
G(1,1)=mean(x_donnees_bruitees);
G(1,2)=mean(y_donnees_bruitees);
distances=sqrt((G(1,1)-x_donnees_bruitees).^2+(G(1,2)-y_donnees_bruitees).^2);
R_moyen=mean(distances); 


end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime,R_estime,critere] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,n_tests,C_tests,R_tests)
     
    % Attention : par rapport au TP1, le tirage des C_tests et R_tests est 
        %             considere comme etant deje effectue 
        %             (il doit etre fait au debut de la fonction RANSAC_3)
    estimation_C_et_R_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
    [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
    C_aleatoire=C_tests;
    R_aleatoire=R_tests;
    C_x=repmat(C_aleatoire(:,1),1,length(x_donnees_bruitees));
    C_y=repmat(C_aleatoire(:,2),1,length(x_donnees_bruitees));
    X_rep=repmat(x_donnees_bruitees,length(C_aleatoire),1);
    Y_rep=repmat(y_donnees_bruitees,length(C_aleatoire),1);
    distances_c=sqrt((C_x-X_rep).^2+(C_y-Y_rep).^2);
    R_new=repmat(R_aleatoire,1,length(x_donnees_bruitees));
    Somme=sum((distances_c-R_new).^2);
    [Min,indice]=min(Somme);
    C_estime=C_aleatoire(1,indice);
    R_estime=R_aleatoire(indice);

end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres)
     
    % Attention : il faut faire les tirages de C_tests et R_tests ici



end
