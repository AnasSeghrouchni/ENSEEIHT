%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% mgs.m
%--------------------------------------------------------------------------

function Q = mgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
       Q = A;
    Q(:,1)=A(:,1)/norm(A(:,1));
    for i=2:m
        s=A(:,i);
        for j=1:(i-1)
            s=s-s'*Q(:,j).*Q(:,j);
        end
        Q(:,i)=s/norm(s);
    end

end