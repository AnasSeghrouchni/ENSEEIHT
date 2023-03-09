
% TP1 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : Seghrouchni
% Prénom : Anas
% Groupe : 1SN-F

function varargout = fonctions_TP1_proba(varargin)

    switch varargin{1}     
        case 'ecriture_RVB'
            varargout{1} = feval(varargin{1},varargin{2:end});
        case {'vectorisation_par_colonne','decorrelation_colonnes'}
            [varargout{1},varargout{2}] = feval(varargin{1},varargin{2:end});
        case 'calcul_parametres_correlation'
            [varargout{1},varargout{2},varargout{3}] = feval(varargin{1},varargin{2:end}); 
    end

end

% Fonction ecriture_RVB (exercice_0.m) ------------------------------------
% (Copiez le corps de la fonction ecriture_RVB du fichier du meme nom)
function image_RVB = ecriture_RVB(image_originale)
    canal_R=image_originale(1:2:end,2:2:end);
    canal_B=image_originale(2:2:end, 1:2:end);
    canal_V1=image_originale(1:2:end,1:2:end);
    canal_V2=image_originale(2:2:end,2:2:end);
    canal_V=(1/2)*(canal_V1+canal_V2);
    image_RVB=cat(3,canal_R,canal_V,canal_B);
end

% Fonction vectorisation_par_colonne (exercice_1.m) -----------------------
function [Vd,Vg] = vectorisation_par_colonne(I)
    [nb_lignes,nb_colonnes] = size(I);
    Vgauche=I(:,1:1:nb_colonnes-1);
    Vdroite=I(:,2:1:end);
    Vg=Vgauche(:);
    Vd=Vdroite(:);
   end

% Fonction calcul_parametres_correlation (exercice_1.m) -------------------
function [r,a,b] = calcul_parametres_correlation(Vd,Vg)
    E_g=mean(Vg);
    E_d=mean(Vd);
    Varg=mean(Vg.*Vg)-mean(Vg)*mean(Vg);
    Vard=mean(Vd.*Vd)-mean(Vd)*mean(Vd);
    sigmag=sqrt(Varg);
    sigmad=sqrt(Vard);
    cov=mean(Vg.*Vd)-E_d*E_g;
    r=cov/(sigmag*sigmad)
    a=(cov/(sigmad*sigmad))
    b=E_g-a*E_d
    
end

% Fonction decorrelation_colonnes (exercice_2.m) --------------------------
function [I_decorrelee,I_min] = decorrelation_colonnes(I,I_max)
 I_decorrelee=I;
 Ig=I(:,1:1:end-1);
 I_decorrelee(:,2:end)=I_decorrelee(:,2:end)-Ig;
 I_min=-I_max
 end



