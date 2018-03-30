clear
l = 1;
R1 = 18.2;
R2 = 18.6;
A = acos( (R1^2 + R2^2 - 4*l^2)/(2*R1*R2));
x = (2*R1*R2*l*cos(A) - 2*R2^2*l + R1*R2*sin(A)*(R1^2*cos(A)^2 + R1^2*sin(A)^2 + R2^2 - 4*l^2 - 2*R1*R2*cos(A))^(1/2))/(R1^2*cos(A)^2 + R1^2*sin(A)^2 + R2^2 - 2*R1*R2*cos(A));
H = (R2*(1 - x^2/R2^2)^(1/2)*(2*R1*R2*l*cos(A) - 2*R2^2*l + R1*R2*sin(A)*(R1^2*cos(A)^2 + R1^2*sin(A)^2 + R2^2 - 4*l^2 - 2*R1*R2*cos(A))^(1/2)))/(x*(R1^2*cos(A)^2 + R1^2*sin(A)^2 + R2^2 - 2*R1*R2*cos(A)));
arg = atan((l + x)/H);
arg = arg*180/pi;