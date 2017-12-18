f0 = 0;
b = 2.04*10^6;
f1 = f0 + b*1;
t = 0:1:255;
y = chirp(t,0,1,f1);
plot(y);
%semilogx(abs(fft(y)));



