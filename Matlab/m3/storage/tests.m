function A1in1 = 
clear A1in A2in x
EQ256 = 16;
EQ64 = 8;
for i = 1:EQ64
    x = 0;
    for j = 1:EQ256
        signal = sin(x);
        A1in(i,j) = signal;
        signal = sin(x+0.1);
        A2in(i,j) = signal;        
        x = x + 2*pi/EQ256;
    end;
end;
