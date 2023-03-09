close all;
clear;

%Déclaration des variables
Rb=2000;
Rs=1000;
Fe=10000;
fp=2000;
alpha=0.35;
Te=1/Fe;
Ts=1/Rs;
Ns=Ts/Te;

%Génération d'un signal
nb_bits=5000;
bits=randi([0 1],1,2*nb_bits);

%Mapping
ak=1-2*bits(1:2:end);
bk=1-2*bits(2:2:end);
dk=ak+1i*bk;

%Suréchantillonage
Suite_diracs=kron(dk, [1 zeros(1,Ns-1)]);

%Filtré avec le filtre de reception
h=rcosdesign(alpha,8,Ns);
x=filter(h,1,Suite_diracs);

%Tracé
figure
nexttile
plot(real(x));
title('Voie en phase');
nexttile
plot(imag(x));
title('Voie en quadrature');
nexttile
plot(x,'*');
title('Signal transmis sur fréquence porteuse');

%Transposition de fréquence

[DSP,f]=pwelch(x,[],[],[],Fe,'centered'); %% centered permet de ramener la DSP sans la porteuse

%Tracé
nexttile
semilogy(f,DSP);
grid on
title('DSP du signal modulé sur fréquence porteuse');

%Filtre de reception
z= filter(h,1,x);

%Diagramme de l'oeil
nexttile
zr=real(z);
plot(reshape(zr,Ns,length(zr)/Ns));
title("Diagramme de l'oeil");
n0=1;

%Echantillonage
zm=z(n0:Ns:end);

%Constellation
nexttile
plot(zm,'*');

%Decisions et démapping
ak_chap=sign(real(zm));
bk_chap=sign(imag(zm));
dk_chap=ak_chap+1i*bk_chap;
%Retard de Nc=span*Ns+1, retard (Nc-1/2)*Te
dk_chap(1:8)=[];


bits_chap=[-real(dk_chap)+1; -imag(dk_chap)+1]./2;
bits_chap=reshape(bits_chap, 1,[]);

%TE
taux_erreur_opti=length(bits_chap(bits_chap ~= bits(1:end-2*8)))/length(bits_chap)

%Ajout du bruit
figure
EbN0_decibel=0:40;
EbN0=10.^(EbN0_decibel./10);
taux_erreur_b=zeros(1,length(EbN0));
logM=2;

for i=1:5:length(EbN0)
    P_x = mean(abs(x).^2);
    sigma_n=sqrt((P_x*Ns)/(2*logM*EbN0(i)));
    bruit_r = sigma_n * randn(1, length(x));
    bruit_i = sigma_n * randn(1, length(x));
    bruit=bruit_r+1i*bruit_i;
    %%Demodulation avec bruit
    %Filtrage de reception (ajout du bruit)
    %Retour en Bande de Base
    zub = (x+bruit) ;

    zb=filter(h,1,zub);
    %Echantillonage
    zmb=zb(n0:Ns:end);
    %Constellation en sortie de l'échantilloneur
    nexttile
    plot(zmb,'*');
    title("Constelation pour Eb/N0="+EbN0_decibel(i)+"db")
    %Decisions et démapping
    ak_chapb=sign(real(zmb));
    bk_chapb=sign(imag(zmb));
    dk_chapb=ak_chapb+1i*bk_chapb;
    %Retard de Nc=span*Ns+1, retard (Nc-1/2)*Te
    dk_chapb(1:8)=[];
    bits_chapb=[-real(dk_chapb)+1; -imag(dk_chapb)+1]./2;
    bits_chapb=reshape(bits_chapb, 1,[]);
    %Calcul du taux d'erreur bianire.
    taux_erreur_b_i=length(bits_chapb(bits_chapb ~= bits(1:end-2*8)))/length(bits_chapb);
    taux_erreur_b(i)=taux_erreur_b_i;

end
%Constelation en sortie du mapping
plot(dk,'*')
title("Constelation en sortie du mapping");

%TEB
figure
nexttile
semilogy(EbN0_decibel,taux_erreur_b,'*-');
hold on
semilogy(EbN0_decibel,qfunc(sqrt(2*EbN0)))
grid on
load('taux_erreur_b_fp.mat');
hold on 
semilogy(EbN0_decibel,taux_erreur_b_fp,'*-');
legend('TEB chaine passe bas','TEB théorique','TEB chaine sur fréquence porteuse')



