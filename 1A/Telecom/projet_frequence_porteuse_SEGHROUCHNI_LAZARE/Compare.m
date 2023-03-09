clear
close all
load("taux_erreur_b_qam.mat");
load("taux_erreur_b_ask.mat")
load("taux_erreur_psk.mat")
load("taux_erreur_b_qpsk.mat")
load("EbN0.mat")
figure
semilogy(EbN0_decibel,taux_erreur_b_qpsk,'*-');
hold on
%semilogy(EbN0_decibel,taux_erreur_b_ask,'*-');
M=4;
EbN0=10.^(EbN0_decibel./10);
semilogy(EbN0_decibel,(1-1/M).*qfunc(sqrt(6*log2(M).*EbN0./(M^2-1))),'*-');
hold on
semilogy(EbN0_decibel,taux_erreur_b_qam,'*-');
hold on
semilogy(EbN0_decibel,taux_erreur_b_psk,'*-');
legend('QPSK','4-ASK','16-QAM','8-PSK');
grid on
title('Comparaison des différentes chaînes de transmission')