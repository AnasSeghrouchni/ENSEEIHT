
close all
clear

Fe=24000;
Rb=3000;
%Modulation 1
%Definition de variables
logM=1;
Rs=Rb/logM;
Te=1/Fe;
Ts=1/Rs;
Ns=Ts/Te;
figure

%Nombre de bits générés
nb_bits=3000;
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
axis([0 nb_bits-1 -1.5 1.5]);
title("Signal généré")
%Calcul de la dsp.
dsp_1=fftshift(pwelch(x,[],[],[],Fe,'twosided'));
f=linspace(-Fe/2,Fe/2,length(dsp_1));
nexttile;
semilogy(f,dsp_1./max(dsp_1));

%Calcul de la dsp théorique.
dsp_theorique=Ts*(sinc(f*Ts)).^2;
hold on;
semilogy(f,dsp_theorique./max(dsp_theorique));
xlabel("Frequence en Hz")
title("Densité spectrale du signal")
legend("Simulée","Théorique")

%Modulation 2
logM2=2;
Rs2=Rb/logM2;
Te=1/Fe;
Ts2=1/Rs2;
Ns2=Ts2/Te;

%Nombre de bits générés
nb_bits=3000;
%Génération de l’information binaire
bits=randi([0,1],1,nb_bits);
bits_2=reshape(bits, [2,length(bits)/2]);
dec=bi2de(bits_2');
%Mapping binaire à moyenne nulle : 0->-3; 1->-1 ; 2->1 ; 3->3
symb=2*dec-3;
%Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs2=kron(symb', [1 zeros(1,Ns2-1)]);
%Génération de la réponse impulsionnelle du filtre de mise en forme (NRZ)
he=ones(1,Ns2);
%Filtrage de mise en forme
x2=filter(he,1,Suite_diracs2);
%Affichage du signal généré

nexttile;
plot(x2);
axis([0 nb_bits-1 -3.5 3.5]);
title("Signal généré")
%TF
dsp_2=fftshift(pwelch(x2,[],[],[],Fe,'twosided'));
f=linspace(-Fe/2,Fe/2,length(dsp_2));
nexttile;

semilogy(f,dsp_2./max(dsp_2));

dsp_theorique2=Ts2*(sinc(f*Ts2)).^2;
hold on;
semilogy(f,dsp_theorique2./max(dsp_theorique2));
title("Densité spectrale du signal")
xlabel("Frequence en Hz")
legend("Simulée","Théorique")

%% Modulateur 3
alpha=0.5;
L=8;
%Durée symbole en nombre d'échantillons (Ts3=Ns3*Te)
Ns3 = Fe/Rb;
Ts3 = Te * Ns3;
%Nombre de bits générés
nb_bits3 = 3000;
%Génération de l’information binaire
bits3=randi([0,1],1,nb_bits);
%Mapping binaire à moyenne nulle : 0->-1, 1->1
Symboles3 = bits3 * 2 - 1;
%Génération de la suite de Diracs pondérés par les symbols (suréchantillonnage)
Suite_diracs3=kron(Symboles3, [1 zeros(1,Ns2-1)]);
%Génération de la réponse impulsionnelle du filtre de mise en forme (NRZ)
h3=rcosdesign(alpha,L,Ns3);
%Filtrage de mise en forme
x3=filter(h3,1,Suite_diracs3);
%Affichage du signal généré
nexttile;
plot(x3);
title("Signal généré")
axis([0 nb_bits3/2-1 -1.5 1.5]);
%Calcul de la DSP
DSP3 = fftshift(pwelch(x3,[],[],[],Fe,'twosided'));
f3=linspace(-Fe/2,Fe/2,length(DSP3));
cond1 = find(abs(f3)<=(1-alpha)/(2*Ts3));
cond2 = find(abs(f3)<=(1+alpha)/(2*Ts3) & abs(f3)>=(1-alpha)/(2*Ts3));
Sx3 = zeros(length(f3), 1);
Sx3(cond1')=Ts3;
Sx3(cond2')=Ts3/2*(1+cos(pi*Ts3/alpha*(abs(f3(cond2'))-(1-alpha)/(2*Ts3))));
% affichage 
nexttile;
semilogy(f3, DSP3./max(DSP3));
title("Densité spectrale du signal")
hold on;
semilogy(f3, Sx3'./max(Sx3));
xlabel("Frequence en Hz")
legend("Simulée","Théorique")

figure
semilogy(f,dsp_1./max(dsp_1));
hold on
semilogy(f,dsp_2./max(dsp_2));
hold on
semilogy(f3, DSP3'./max(DSP3));
legend("Mod 1","Mod 2","Mod 3")
xlabel("Frequence en Hz")
title("DSP des signaux générés par les différents modulateurs étudiés")




