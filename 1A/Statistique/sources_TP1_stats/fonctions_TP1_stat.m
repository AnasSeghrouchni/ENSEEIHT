
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Seghrouchni 
% Prénom : Anas
% Groupe : 1SN-F

function varargout = fonctions_TP1_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction G_et_R_moyen (exercice_1.m) ----------------------------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
G=zeros(1,2);
G(1,1)=mean(x_donnees_bruitees);
G(1,2)=mean(y_donnees_bruitees);
distances=sqrt((G(1,1)-x_donnees_bruitees).^2+(G(1,2)-y_donnees_bruitees).^2);
R_moyen=mean(distances); 
     
end

% Fonction estimation_C_uniforme (exercice_1.m) ---------------------------
function [C_estime, R_moyen] = ...
         estimation_C_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
[G, R_moyen, distances] =G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
C_aleatoire=(rand(n_tests,2)-1/2)*2*R_moyen+G;
n_donnee=size(x_donnees_bruitees,2);
C_x=repmat(C_aleatoire(:,1),1,length(x_donnees_bruitees));
C_y=repmat(C_aleatoire(:,2),1,length(x_donnees_bruitees));
X_rep=repmat(x_donnees_bruitees,length(C_aleatoire),1);
Y_rep=repmat(y_donnees_bruitees,length(C_aleatoire),1);
distances_c=sqrt((C_x-X_rep).^2+(C_y-Y_rep).^2);
Somme=sum((distances_c-R_moyen).^2);
[Min,indice]=min(Somme);
C_estime=C_aleatoire(indice,:);

end

% Fonction estimation_C_et_R_uniforme (exercice_2.m) ----------------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_uniforme(x_donnees_bruitees,y_donnees_bruitees,n_tests)
[G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees);
C_aleatoire=(rand(n_tests,2)-1/2)*2*R_moyen+G;
R_aleatoire=(rand(n_tests,1)-1/2)+R_moyen;
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

% Fonction occultation_donnees (donnees_occultees.m) ----------------------
function [x_donnees_bruitees, y_donnees_bruitees] = ...
         occultation_donnees(x_donnees_bruitees, y_donnees_bruitees, theta_donnees_bruitees)
theta_1=rand(1)*2*pi;
theta_2=rand(1)*2*pi;
theta_1*180/pi
theta_2*180/pi
if theta_2>theta_1
    x_donnees_bruitees=x_donnees_bruitees(theta_donnees_bruitees>=theta_1 & theta_donnees_bruitees<=theta_2);
    y_donnees_bruitees=y_donnees_bruitees(theta_donnees_bruitees>=theta_1 & theta_donnees_bruitees<=theta_2);
else
    x_donnees_bruitees=x_donnees_bruitees(theta_donnees_bruitees>=theta_1 | theta_donnees_bruitees<=theta_2);
    y_donnees_bruitees=y_donnees_bruitees(theta_donnees_bruitees>=theta_1 | theta_donnees_bruitees<=theta_2);
end

end

% Fonction estimation_C_et_R_normale (exercice_4.m, bonus) ----------------
function [C_estime, R_estime] = ...
         estimation_C_et_R_normale(x_donnees_bruitees,y_donnees_bruitees,n_tests)



end
