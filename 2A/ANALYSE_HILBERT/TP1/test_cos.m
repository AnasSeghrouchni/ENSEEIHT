
J = 10;
N = 2^J;
F = zeros(1,N);
for i = 1:N
    F(i)=sqrt(abs(i/N));
end

[c0,D]=decomposition(F,eps);
[C] = recomposition(D,c0);
figure
plot(C)

