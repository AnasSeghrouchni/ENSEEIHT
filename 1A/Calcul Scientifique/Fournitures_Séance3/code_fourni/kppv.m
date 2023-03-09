%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
% fonction kppv.m
%
% Données :
% DataA      : les données d'apprentissage (connues)
% LabelA     : les labels des données d'apprentissage
%
% DataT      : les données de test (on veut trouver leur label)
% Nt_test    : nombre de données tests qu'on veut labelliser
%
% K          : le K de l'algorithme des k-plus-proches-voisins
% ListeClass : les classes possibles (== les labels possibles)
%
% Résultat :
% Partition : pour les Nt_test données de test, le label calculé
%
%--------------------------------------------------------------------------
function [Partition, nech] = kppv(DataA, labelA, DataT, Nt_test, K, ListeClass)

[Na,~] = size(DataA);

% Initialisation du vecteur d'étiquetage des images tests
Partition = zeros(Nt_test,1);

disp(['Classification des images test dans ' num2str(length(ListeClass)) ' classes'])
disp(['par la methode des ' num2str(K) ' plus proches voisins:'])

% Boucle sur les vecteurs test de l'ensemble de l'évaluation
for i = 1:Nt_test
    
    disp(['image test n°' num2str(i)])

    % Calcul des distances entre les vecteurs de test 
    % et les vecteurs d'apprentissage (voisins)
    %N = norm(DataA - DataT(i,:))
    N = sqrt(sum(((DataT(i,:)-DataA).^2),2));
    % On ne garde que les indices des K + proches voisins
    [~,indices] = sort(N);
    Kindices = indices(1:K);
    
    % Comptage du nombre de voisins appartenant à chaque classe
       classes = labelA(Kindices);
%     nech = zeros(length(ListeClass), 1);
%     for j = 1:length(ListeClass)
%         nech(j) = length(find(classes == ListeClass(j)));
%     end
    nech=hist(classes,ListeClass);
    % Recherche de la classe contenant le maximum de voisins
    [~, imax] = max(nech);
    
    % Si l'image test a le plus grand nombre de voisins dans plusieurs  
    % classes différentes, alors on lui assigne celle du voisin le + proche,
    % sinon on lui assigne l'unique classe contenant le plus de voisins
    if (length(imax) > 1)
        laClasse = labelA(Kindices(1));
    else
        laClasse = ListeClass(imax);
    end
    
    % Assignation de l'étiquette correspondant à la classe trouvée au point 
    % correspondant à la i-ème image test dans le vecteur "Partition" 
    Partition(i) = laClasse;
    
    
end
