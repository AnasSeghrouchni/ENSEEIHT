clear; 
close all;

load SG1.mat;
[n,m]=size(ImMod);
[n1,m1]=size(DataMod);

figure
subplot(1,2,1)
hold on
title("Partie vsage Original");
imshow(Data)
axis equal
A=[-Data(:) ones(n1*m1,1)];
B=log(DataMod(:));
