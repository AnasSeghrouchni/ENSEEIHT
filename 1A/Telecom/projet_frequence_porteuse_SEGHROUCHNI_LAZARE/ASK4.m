close all
clear

%constante
M=4;
Rb=48000;
Rs=1000;
Fe=10000;
fp=2000;
alpha=0.5;
Te=1/Fe;
Ts=1/Rs;
Ns=10;

%Nombre de bits générés
nb_bits=10000;
%Génération de l’information binaire
bits=randi([0,1],1,nb_bits);
bits_2=reshape(bits, [2,length(bits)/2]);
dec=bi2de(bits_2');
%Mapping binaire à moyenne nulle : 0->-3; 1->-1 ; 2->1 ; 3->3
symb=2*dec-3;
%Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs=kron(symb', [1 zeros(1,Ns-1)]);

%Filtré avec le filtre de mise en forme
h=rcosdesign(alpha,8,Ns);
x= conv(Suite_diracs, h, 'same');

%Filtre de reception
z= conv(x, h, 'same');

%Diagramme de l'oeil
nexttile
plot(reshape(z,Ns,length(z)/Ns));
title("Diagramme de l'oeil");
n0=1;

%Echantillonage
zm=z(n0:Ns:end);

%Constellation
nexttile
plot(zm,'*');

%decisions
dk=zeros(length(zm),1);
dk(zm>2)=3;
dk(zm >= 0 & zm <= 2) = 1;
dk(zm < 0 & zm >= -2) = -1;
dk(zm<-2)=-3;

%retour en binaire
dm = de2bi((dk+3)/2);
bits_trouve=  reshape(dm', 1, []);

%Calcul du taux d'erreur bianire.
taux_erreur_ASK_4=length(bits_trouve(bits_trouve ~= bits))/length(bits)


%Ajout du bruit
figure
EbN0_decibel=0:6;
EbN0=10.^(EbN0_decibel./10);
taux_erreur_b_ask=zeros(1,length(EbN0));
logM=2;

for i=1:length(EbN0)
    P_x = mean(abs(x).^2);
    sigma_n=sqrt((P_x*Ns)/(2*logM*EbN0(i)));
    bruit_r = sigma_n * randn(1, length(x));
    bruit=bruit_r;
    %%Demodulation avec bruit
    %Filtrage de reception (ajout du bruit)
    %Retour en Bande de Base
    zub = (x+bruit) ;

    zb=conv(zub, h, 'same');

    %Echantillonage
    zmb=zb(n0:Ns:end);
    %Constellation en sortie de l'échantilloneur
    nexttile
    plot(zmb,'*');
    title("Constelation pour Eb/N0="+EbN0_decibel(i)+"db")
    %Decisions et démapping
    dkb=zeros(length(zm),1);
    dkb(zmb > 2)=3;
    dkb(zmb >= 0 & zmb <= 2) = 1;
    dkb(zmb < 0 & zmb >= -2) = -1;
    dkb(zmb < -2)=-3;
    
    %retour en binaire
    dmb = de2bi((dkb+3)/2);
    bits_trouve=  reshape(dmb', 1, []);

    %Calcul du taux d'erreur bianire.
    taux_erreur_b_i=length(bits_trouve(bits_trouve ~= bits))/length(bits);
    taux_erreur_b_ask(i)=taux_erreur_b_i;

end
%Constelation en sortie du mapping
plot(dk,'*')
title("Constelation en sortie du mapping");

%TEB
figure
nexttile
semilogy(EbN0_decibel,taux_erreur_b_ask,'*-');
hold on
semilogy(EbN0_decibel,(1-1/M).*qfunc(sqrt(6*log2(M).*EbN0./(M*M-1))))
grid on
save('taux_erreur_b_ask','taux_erreur_b_ask')
title('TEB 4-ask')
