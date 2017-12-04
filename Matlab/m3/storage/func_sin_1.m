function [A1in,A2in] = func_sin()
    EQ256 = 16;
    EQ64 = 8;
    for i = 1:EQ64
        x = 0;
        for j = 1:EQ256
            signal = sin(x)+sin(2*x)+3*cos(2.5*x)++sin(5*x);
            A1in(i,j) = signal;
            signal = sin(x+0.2)+sin(2*x+0.2)+3*cos(2.5*x+0.2)+sin(5*x+0.2);
            A2in(i,j) = signal;        
            x = x + 2*pi/EQ256;
        end;
    end;
end