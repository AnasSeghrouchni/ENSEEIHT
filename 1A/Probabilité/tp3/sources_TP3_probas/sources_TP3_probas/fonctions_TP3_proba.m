
% TP3 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : SEGHROUCHNI
% Prénom : Anas
% Groupe : 1SN-F

function varargout = fonctions_TP3_proba(varargin)

    switch varargin{1}
        
        case 'matrice_inertie'
            
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
            
        case {'ensemble_E_recursif','calcul_proba'}
            
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end});
    
    end
end

% Fonction ensemble_E_recursif (exercie_1.m) ------------------------------
function [E,contour,G_somme] = ...
    ensemble_E_recursif(E,contour,G_somme,i,j,voisins,G_x,G_y,card_max,cos_alpha)
    contour(i,j)=0;
    Nb_voisins=8;
    k=1;
    while (Nb_voisins-k>=0) && length(E)<card_max 
        i_vois=i+voisins(k,1);
        j_vois=j+voisins(k,2);
        if contour(i_vois,j_vois)==1
            G_voisin=[G_x(i_vois,j_vois), G_y(i_vois,j_vois)];
            if (G_voisin/norm(G_voisin))*(G_somme/norm(G_somme))'>=cos_alpha
                E=[E;[i_vois j_vois]];
                G_somme=G_somme+G_voisin;
                [E,contour,G_somme]=ensemble_E_recursif(E,contour,G_somme,i_vois,j_vois,voisins,G_x,G_y,card_max,cos_alpha);
            end
        end
        k=k+1;
    end  
end

% Fonction matrice_inertie (exercice_2.m) ---------------------------------
function [M_inertie,C] = matrice_inertie(E,G_norme_E)
 PI=sum(G_norme_E);
 E_f=fliplr(E);
 xi=E_f(:,1);
 yi=E_f(:,2);
 x_b=(1/PI)*(xi'*G_norme_E);
 y_b=(1/PI)*(yi'*G_norme_E);
 C=[x_b y_b];
 M_inertie=zeros(2,2);
 M_inertie(1,1)=G_norme_E'*((xi-x_b).*(xi-x_b));
 M_inertie(2,2)=G_norme_E'*((yi-y_b).*(yi-y_b));
 M_inertie(1,2)=G_norme_E'*((yi-y_b).*(xi-x_b));
 M_inertie(2,1)=M_inertie(1,2);
 M_inertie=1/PI*M_inertie;
end

% Fonction calcul_proba (exercice_2.m) ------------------------------------
function [x_min,x_max,probabilite] = calcul_proba(E_nouveau_repere,p)
    x_min=min(E_nouveau_repere(:,1));
    x_max=max(E_nouveau_repere(:,1));
    y_min=min(E_nouveau_repere(:,2));
    y_max=max(E_nouveau_repere(:,2));
    N=round((x_max-x_min)*(y_max-y_min));
    n=length(E_nouveau_repere);
    probabilite=1-binocdf(n-1,N,p);  
end
