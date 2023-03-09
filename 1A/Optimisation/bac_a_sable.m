n=4;m=5;
I=eye(n,m);
Jac=zeros(n,m);
for k=1:m
    vk=I(:,k)
    Jac(:,k)=vk;
end
eps
