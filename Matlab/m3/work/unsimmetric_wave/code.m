clear
x = 1:0.1:10;
fi = 10*pi/180;
y1 = sin(x);
y2 = exp(fi*sqrt(-1))*sin(x);

x1 = imag(y1)./real(y1);
x2 = imag(y2)./real(y2);
%arg = atan(x1) - atan(x2);
arg = atan( (x1 - x2)./(x1 + x2) ) ;