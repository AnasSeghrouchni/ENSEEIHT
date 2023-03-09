figure 

%question 1
f0=1100;
Fe1=10000;
Te1=1/Fe1;
N=90;
echant1=cos(2*pi*[0:Te1:(N-1)*Te1]*f0);
x1=linspace(0,(N-1)*Fe1);
nexttile;
plot(x,echant1);
xlabel("Temps");
ylabel("Signal");

%Question 3
Fe2=1000;
Te2=1/Fe2;
echant2=cos(2*pi*[0:Te2:(N-1)*Te2]*f0);
x2=linspace(0,(N-1)*Te2);
size(echant2);
size(x);
nexttile;
plot(x,echant2)
xlabel("Temps");
ylabel("Signal");

four=fft(echant1);
four2=fft(echant2,2048);
four3=fftshift(fft(cos(2*pi*f0*(1:90)*Te1),2048));

semilogy(linspace(-Te1/2,Te1/2,2048),abs(four3));
%question2.4



