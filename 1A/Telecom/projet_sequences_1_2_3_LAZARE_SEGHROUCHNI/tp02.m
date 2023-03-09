

clear;
close all;

Fe=24000; %Frequence d'échantillonage

Rb=3000; %Debit Binaire

%% Modulation rectangulaire

%Definition de variables
logM=1; 
Rs=Rb/logM; %Debit symbole
Te=1/Fe;
Ts=1/Rs;
Ns=Ts/Te;

figure

%Nombre de bits générés
nb_bits=1000;
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
%Affichage du signal généré.
nexttile;
plot(x);
title('Signal généré aléatoirement (avec mapping à moyenne nulle)');
axis([0 nb_bits-1 -1.5 1.5]);
nexttile
%%Demodulation
%La reponse impulsionelle du filtre de reception
hr=h;
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
n0=8;
%Echantillonage du signal reçu.
xechant=xdemod(n0:Ns:length(xdemod));

%Démapping adapté au mapping réalisé.
s_demod=(sign(xechant)+1)./2;

%Calcul du taux d'erreur bianire.
taux_erreur_opti=length(s_demod(s_demod ~= bits))/nb_bits
%Le taux d'erreur binaire est bien égale à 0.

%Question 8, changement de n0 afin de calculer de nouveau le TEB
xechant2=xdemod(3:Ns:length(xdemod));
s_demod2=(sign(xechant2)+1)./2;
taux_erreur_pas_bien=length(s_demod2(s_demod2 ~= bits))/nb_bits
%Pour n0=3 le critère de Nyquist n'est plus respecté (on peut le voir sur le diagramme de l'oeil), ainsi le TEB est
%moins bon que pour n0=8.


%% partie 2
figure
N=101; %ordre du filtre
fc1=8000; %frequence de coupure
%Reponse impulsionnelle du filtre du canal de propagation.
hc1 =(2*fc1/Fe)*sinc(2*(fc1/Fe)*[-(N-1)/2:(N-1)/2]);

%Réponse impulsionnelle globale de la chaine de transmission.
htot=conv(conv(h,hr),hc1 );

%Affichage de cette dernière.
plot(htot')
title("Réponse impulsionnelle globale ")
%Signal recu après la chaine de transmission
x_sorti_canal=filter(htot,1,Suite_diracs);
nexttile;

%Diagramme de l'oeil de la chaine de transmision
plot(reshape(x_sorti_canal,Ns,length(x_sorti_canal)/Ns))
title("Diagramme de l'oeil à la sortie du filtre de réception. Pour fc="+fc1+"Hz");
%Afficher les dsp sur un même graphe
H=fftshift(fft(h,1024));
Hc=fftshift(fft(hc1,1024));
Hr=fftshift(fft(hr,1024));
nexttile;
plot(abs(H.*Hr)./max(abs(H.*Hr)));
hold on
plot(abs(Hc)./max(abs(Hc)));
legend('|H(f)*H_r(f)|','|H_c(f)|')
%Nous avons vu dans la partie présente que H(f)*H_r(f) permet de respecter
%le critère de Nyquist. Cependant ici il faut que H(f)*H_r(f)*H_c(f) puisse
%valider ce critère. Or on remarque sur le graphique que H_c ne modifie pas
%la forme de H(f)*H_r(f) permettant de respecter ke critère de Nyquist.
%Nous avons donc un TEB de 0.


%Echantillonage avec un bon n0 puis démapping.
xechant3=x_sorti_canal(2:Ns:length(x_sorti_canal));
s_demod3=(sign(xechant3)+1)./2;

%Calcul du taux d'erreur binaire. Attention au décalage
TEB_1=length(s_demod3(s_demod3(8:1000) ~= bits(1:993)))/nb_bits


%Question 2
figure
N=101; %ordre du filtre
fc2=1000; %frequence de coupure
%Reponse impulsionnelle du filtre du canal de propagation.
hc2 =(2*fc2/Fe)*sinc(2*(fc2/Fe)*[-(N-1)/2:(N-1)/2]);

%Réponse impulsionnelle globale de la chaine de transmission.
htot2=conv(conv(h,hr),hc2);

%Affichage de cette dernière.
plot(htot2)

%Signal recu après la chaine de transmission
x_sorti_canal2=filter(htot2,1,Suite_diracs);
nexttile;

%Diagramme de l'oeil de la chaine de transmision
plot(reshape(x_sorti_canal2,Ns,length(x_sorti_canal2)/Ns))
title("Diagramme de l'oeil à la sortie du filtre de réception. Pour fc="+fc2+"Hz");
%Afficher les dsp sur un même graphe
H=fftshift(fft(h,1024));
Hc2=fftshift(fft(hc2,1024));
Hr=fftshift(fft(hr,1024));
nexttile;
plot(abs(H.*Hr)./max(abs(H.*Hr)));
hold on
plot(abs(Hc2)./max(abs(Hc2)));
legend('|H(f)*H_r(f)|','|H_c(f)|')
%Ici on remarque sur le graphique que H_c modifie
%la forme de H(f)*H_r(f) et donc H(f)*H_r(f)*H_c(f) ne peut plus respecter le critère de Nyquist.
%Nous avons donc un TEB plus grand que 0.


%Echantillonage avec un bon n0 puis démapping.
xechant4=x_sorti_canal2(2:Ns:length(x_sorti_canal2));
s_demod4=(sign(xechant4)+1)./2;

%Calcul du taux d'erreur binaire. Attention au décalage
TEB_2=length(s_demod4(s_demod4(8:1000) ~= bits(1:993)))/nb_bits

