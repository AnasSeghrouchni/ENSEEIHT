function [c0,D]=decomposition(F,eps)
    %taille du tableau
    j = log2(length(F));
    D = zeros(j+1,(2^j));
    C = zeros(j+1,(2^j));
    C(j+1,:) = F;
    N = 0;
    Neps = 0;
    
    %calcul des d_k
    for i = j-1:-1:0
        for k = 1:2^(i-1)
            C(i,k) = (C(i+1,2*k) + C(i+1,2*k+1))/sqrt(2);
            D(i,k) = (C(i+1,2*k) - C(i+1,2*k+1))/sqrt(2);
        end        
    end
    
    %conserver uniquement superieur à eps
    for i = 1:j+1
        for k = 1:2^(i-1)
            if abs(D(i,k)) < eps
                D(i,k) = 0;
                Neps = Neps +1;
            end
            N = N+1;
        end
    end
    %Construction de F
    c0 = C(1,1);
    
end