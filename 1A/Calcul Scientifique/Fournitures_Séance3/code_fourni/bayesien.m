function [mu, sigma]=estimation_mu_Sigma(X)
 X_c=X-mean(X);
 n=length(X);
 sigma=(1/n).*X_c'*X_c;
 mu=(1/n).*X'*ones(n,1);
 
end



function 