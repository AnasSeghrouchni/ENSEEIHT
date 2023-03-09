figure
%question 1
f1=1000;
f2=3000;
Fe=10000;
Te=1/Fe;
N=100;
x=(1:N)*Te;
echant=cos(2*pi*x*f1)+cos(2*pi*x*f2);
size(echant)

%question 2

nexttile;
plot(x,echant);
xlabel("Temps en s");
ylabel("Signal");

%question 3
four=fftshift(fft(echant));
nexttile;
plot(linspace(-Fe/2 ,Fe/2),abs(four));
xlabel("Frequence en Hz");
ylabel("Amplirude");

%question 4
f3=2000;
x30=(-30:30)*Te;
h30=2*f3*sinc(x5*2*f3);
four1=fftshift(fft(h30));
nexttile;
plot((-30:30)*Fe,abs(four1));
nexttile;
x5=(-5:5)*Te;
h2=2*f3*sinc(x5*2*f3);
four2=fftshift(fft(h2));
plot((-5:5)*Fe,abs(four2));
