clear all
close all
nb_symboles=6;
M=8;
bits=randi([0 1], 1, nb_symboles*log2(M));
bits_3=reshape(bits, [3,length(bits)/3]);
symboles = bi2de(bits_3')
dk = pskmod(symboles,M,0,'gray').';
y = pskdemod(dk, M, 0, 'gray')