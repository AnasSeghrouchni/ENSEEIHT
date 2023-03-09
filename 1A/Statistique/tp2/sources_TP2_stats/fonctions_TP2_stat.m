
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Seghrouchni
% Prénom : Anas
% Groupe : 1SN-F

function varargout = fonctions_TP2_stat(varargin)

    [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
x_G=mean(x_donnees_bruitees);

y_G=mean(y_donnees_bruitees);
x_donnees_bruitees_centrees=x_donnees_bruitees-x_G;
y_donnees_bruitees_centrees=y_donnees_bruitees-y_G;
   
     
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] =centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
phi=rand(n_tests,1)*pi-pi/2;
C_aleatoire=repmat(phi,1,length(x_donnees_bruitees_centrees));
X_rep=repmat(x_donnees_bruitees_centrees,length(phi),1);
Y_rep=repmat(y_donnees_bruitees_centrees,length(phi),1);
k=Y_rep-tan(C_aleatoire).*X_rep;
somme=sum(k.*k,2);
[mini,indi]=min(somme);
a_Dyx=tan(C_aleatoire(indi,1));
b_Dyx=y_G-a_Dyx*x_G;





    
end

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
l_2=ones(1,length(x_donnees_bruitees));
A=[x_donnees_bruitees;l_2]';
B=y_donnees_bruitees';
res=A\B;
a_Dyx=res(1,1);
b_Dyx=res(2,1);


    
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,n_tests)
theta=rand(n_tests,1)*pi;
[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] =centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
C_aleatoire=repmat(theta,1,length(x_donnees_bruitees_centrees));
X_rep=repmat(x_donnees_bruitees_centrees,length(theta),1);
Y_rep=repmat(y_donnees_bruitees_centrees,length(theta),1);
k=X_rep.*cos(C_aleatoire)+Y_rep.*sin(C_aleatoire);
somme=sum(k.*k,2);
[mini,indi]=min(somme);
theta_Dorth=C_aleatoire(indi,1);
rho_Dorth=x_G*cos(theta_Dorth)+y_G*sin(theta_Dorth);

end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)
[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] =centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
C=[x_donnees_bruitees_centrees;y_donnees_bruitees_centrees]';
new=C'*C;
[V,D]=eig(new);
[mini,indi]=min(diag(D));
y_etoile=V(:,indi)/norm(V(:,indi));
theta_Dorth=atan2(y_etoile(2),y_etoile(1));
rho_Dorth=x_G*cos(theta_Dorth)+y_G*sin(theta_Dorth);




end
