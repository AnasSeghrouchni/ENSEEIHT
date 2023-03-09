close all;
clear;

%constante
M=4;
Rb=48000;
Rs=1000;
Fe=10000;
fp=2000;
alpha=0.5;
Te=1/Fe;
Ts=1/Rs;
Ns=2;

%Génération d'un signal
nb_symboles=10000;
bits=randi([0 1], 1, nb_symboles*log2(M));
bits_2=reshape(bits, [2,length(bits)/2]);
symboles = bi2de(bits_2');


%Génération d'un message complexe en bande de base
dk = pskmod(symboles,M,pi/4,'gray').'; 

%Suréchantillonage
Suite_diracs=kron(dk, [1 zeros(1,Ns-1)]);

%Filtré avec le filtre de mise en forme
h=rcosdesign(alpha,8,Ns);
x= conv(Suite_diracs, h, 'same');

%Tracé
figure
nexttile
plot(real(x));
title('Voie en phase');
nexttile
plot(imag(x));
title('Voie en quadrature');
nexttile
plot(x, '*');
title('Signal transmis au canal');

%Filtre de reception
z= conv(x, h, 'same');

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

%démodulation en bande de base 
y = pskdemod(zm, M, pi/4, 'gray'); 

%retour en binaire
dm = de2bi(y);
dm_chap = reshape(dm', 1, []);

%Calcul du taux d'erreur bianire.
taux_erreur_b_QPSK=length(dm_chap(dm_chap ~= bits))/length(dm_chap)

%Ajout du bruit
figure
EbN0_decibel=0:6;
EbN0=10.^(EbN0_decibel./10);
taux_erreur_b_qpsk=zeros(1,length(EbN0));
logM=2;

for i=1:length(EbN0)
    P_x = mean(abs(x).^2);
    sigma_n=sqrt((P_x*Ns)/(2*logM*EbN0(i)));
    bruit_r = sigma_n * randn(1, length(x));
    bruit_i = sigma_n * randn(1, length(x));
    bruit=bruit_r+1i*bruit_i;
    %%Demodulation avec bruit
    %Filtrage de reception (ajout du bruit)
    %Retour en Bande de Base
    zub = (x+bruit) ;

    %Filtre de reception
    zb = conv(zub,h,'same');
    %Echantillonage
    zmb=zb(1:Ns:end);
    %Constellation en sortie de l'échantilloneur
    nexttile
    plot(zmb,'*');
    title("Constelation pour Eb/N0="+EbN0_decibel(i)+"db")
    %Decisions et démapping
    yb=pskdemod(zmb,M,pi/4,'gray');
    %retour en binaire
    dmb = de2bi(yb);
    dm_chapb = reshape(dmb', 1, []);

    %Calcul du taux d'erreur bianire.
    taux_erreur_b_i=length(dm_chapb(dm_chapb ~= bits))/length(dm_chapb);
    taux_erreur_b_qpsk(i)=taux_erreur_b_i;

end
%Constelation en sortie du mapping
plot(dk,'*')
title("Constelation en sortie du mapping");

%TEB
figure
nexttile
semilogy(EbN0_decibel,taux_erreur_b_qpsk,'*-');
hold on
semilogy(EbN0_decibel,2/logM*qfunc(sqrt(2*EbN0*logM).*sin(pi/M)))
grid on
legend('TEB chaine passe bas','TEB théorique');
title ('TEB qpsk')
save('taux_erreur_b_qpsk','taux_erreur_b_qpsk');
save("EbN0",'EbN0','EbN0_decibel');