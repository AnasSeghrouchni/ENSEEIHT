function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 
L=sparse([]);
A=eye(N2);
nu1=nu(1,1);
nu2=nu(2,1);
b1=nu1/(dx1*dx1);
b2=nu2/(dx2*dx2);
a=2*(b1+b2);
A=a.*A;
for i=2:(N2-1)
    A(i,1+i)=-b1;
    A(1+i,i)=-b1;
end
D=(-b2).*eye(N2);
size(A)
size(D)
AD=[A,D;D,A];
Ac = repmat({AD}, 1, (N1/2));  
L = blkdiag(Ac{:});


% Initialisation


%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TO DO %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

end    
