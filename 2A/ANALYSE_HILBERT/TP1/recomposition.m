function [L] = recomposition(D,c0)
    [j,n] = size(D);
    C = zeros(j,n);
    C(1,1) = c0;
    for i = 1:j
        for k = 1:n
            C(i+1,2*k) = (C(i,k) + D(i,k))/sqrt(2);
            C(i+1,2*k+1) = (C(i,k) - C(i,k))/sqrt(2);
        end
    end
    L = C(j+1,:);
end

