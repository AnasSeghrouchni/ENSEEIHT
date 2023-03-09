clear;
close all;

Fe=24000; %Frequence d'échantillonage

Rb=3000; %Debit Binaire

%% Reprise du tp précedent : on remarque bien que le TEB est nul
%%Modulation rectangulaire

%Definition de variables
logM=1; 
Rs=Rb/logM; %Debit symbole
Te=1/Fe;
Ts=1/Rs;
Ns=Ts/Te;

figure

%Nombre de bits générés
nb_bits=5000;
%Génération de l’information binaire
bits=randi([0,1],1,nb_bits);
%Mapping binaire à moyenne nulle : 0->-1, 1->1
Symboles=2*bits-1;
%Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs=kron(Symboles, [1 zeros(1,Ns-1)]);
%Génération de la réponse impulsionnelle du filtre de mise en forme (NRZ).
h=ones(1,Ns);
%Filtrage de mise en forme.
x=filter(h,1,Suite_diracs);

%%Demodulation
%La reponse impulsionelle du filtre de reception
hr=[1 1 1 1 0 0 0 0];
%Filtrage de reception
xdemod=filter(hr,1,x);
%Affichage du signal reçu.
plot(xdemod);
title('Signal reçu')
nexttile;
%Affichage du diagramme de l'oeil.
plot(reshape(xdemod,Ns,length(xdemod)/Ns))
title("Diagramme de l'oeil à la sortie du filtre de réception");
%n0 obtenu après analyse du diagramme de l'oeil. 
% Le diagramme de l'oeil n'est pas conforme a ce qui est attendu en
% réalité, on a bien la première transition, cepandant le diagramme semble
% coupé à gauche.
n0=8;
%Echantillonage du signal reçu.
xechant=xdemod(n0:Ns:length(xdemod));

%Démapping adapté au mapping réalisé.
s_demod=(sign(xechant)+1)./2;

%Calcul du taux d'erreur bianire.
taux_erreur_opti=length(s_demod(s_demod ~= bits))/nb_bits
%Le taux d'erreur binaire est bien égale à 0.

%% Ajout du bruit
figure
EbN0_decibel=0:8;
EbN0=10.^(EbN0_decibel./10);
taux_erreur_b=zeros(1,length(EbN0));
for i=1:length(EbN0)
    P_x = mean(abs(x).^2);
    sigma_n=sqrt((P_x*Ns)/(2*logM*EbN0(i)));
    bruit = sigma_n * randn(1, length(x));
    %%Demodulation avec bruit
    %La reponse impulsionelle du filtre de reception
    hr=[1 1 1 1 0 0 0 0];
    %Filtrage de reception (ajout du bruit)
    xdemod_b=filter(hr,1,x+bruit);
    % %Affichage du diagramme de l'oeil.
    % plot(reshape(xdemod_b,Ns,length(xdemod_b)/Ns))
    % title("Diagramme de l'oeil pour E_b/N_0="+EbN0);
    % %n0 obtenu après analyse du diagramme de l'oeil. 
    n0=8;
    %Echantillonage du signal reçu.
    xechant_b=xdemod_b(n0:Ns:length(xdemod_b));
    %Démapping adapté au mapping réalisé.
    s_demod_b=(sign(xechant_b)+1)./2;
    
    %Calcul du taux d'erreur bianire.
    taux_erreur_b_i=length(s_demod_b(s_demod_b ~= bits))/nb_bits
    taux_erreur_b(i)=taux_erreur_b_i;

end

nexttile
semilogy(EbN0_decibel,taux_erreur_b,'*-');
hold on
semilogy(EbN0_decibel,qfunc(sqrt(2*EbN0)))
grid on

