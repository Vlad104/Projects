%clear
EQ256 = 16;
EQ64 = 8;

%[A1in,A2in] = func_sin_1();

%A1in = A1in';
%A2in = A2in';

A1in = SS;
A2in = SSS;

A1 = fft(A1in(:,:));
A2 = fft(A2in(:,:));

A1 = A1';
A2 = A2';
    
B1 = fft(A1(:,:));
B2 = fft(A2(:,:));

C = abs(B1) + abs(B2);
S1 = 0; S2 = 0; 
tr = 1;

C(:,:) = C(:,:).*1000;

for i = 1:EQ64
    for j = 1:EQ256
        if (6-j <= 0 && j <= (EQ256-5))
            S1 = C(i,j-5) + C(i,j-4) + C(i,j-3);
            S1 = S1/3;
            S2 = C(i,j+3) + C(i,j+4) + C(i,j+5);
            S2 = S2/3;
            if ( ( (tr*S1 < C(i,j)) && (tr*S2 < C(i,j)) ) )
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;    
        if (j <= 2)
            S2 = C(i,j+3) + C(i,j+4) + C(i,j+5);
            S2 = S2/3;
            if (tr*S2 < C(i,j))
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;    
        if (j >= EQ256-2)
            S1 = C(i,j-5) + C(i,j-4) + C(i,j-3);
            S1 = S1/3;
            if (tr*S1 < C(i,j))
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end; 
        if (j == 4)
            S1 = C(i,j-3);
            S2 = C(i,j+3) + C(i,j+4) + C(i,j+5);
            S2 = S2/3;
            if ( (tr*S1 < C(i,j)) && (tr*S2 < C(i,j)) )
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;         
        if (j == 5)
            S1 = C(i,j-4) + C(i,j-3);
            S1 = S1/2;
            S2 = C(i,j+3) + C(i,j+4) + C(i,j+5);
            S2 = S2/3;
            if ( (tr*S1 < C(i,j)) && (tr*S2 < C(i,j)) )
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;
        if (j == EQ256 - 3)
            S1 = C(i,j-5) + C(i,j-4) + C(i,j-3);
            S1 = S1/3;
            S2 = C(i,j+3);
            if ( (tr*S1 < C(i,j)) && (tr*S2 < C(i,j)) )
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;
        if (j == EQ256 - 4)
            S1 = C(i,j-5) + C(i,j-4) + C(i,j-3);
            S1 = S1/3;
            S2 = C(i,j+3) + C(i,j+4);
            S2 = S2/2;
            if ( (tr*S1 < C(i,j)) && (tr*S2 < C(i,j)) )
                D(i,j) = int32(C(i,j));
            else
                D(i,j) = 0;
            end;
        end;      
    end;
end;

%F for phase
for i = 1:EQ64
    for j = 1:EQ256
        if ( D(i,j) > 0 )
            E(i,j) = atan( imag(B1(i,j))/real(B1(i,j)) ) - atan( imag(B2(i,j))/real(B2(i,j)) );
        else
            E(i,j) = atan( imag(B1(i,j))/real(B1(i,j)) ) - atan( imag(B2(i,j))/real(B2(i,j)) );
        end;            
    end;
end;

G(1:EQ64,1:EQ256) = 0;
F(1:int32(EQ64*EQ256/2),:) = 0; % 1- номер обл, 2-сумм мощность, 3-дальность, 4- скор, 5 - угол, кол-во точек (не нужно)
H(1:EQ64,1:EQ256) = 0;
K(1:EQ256/4*EQ64/4,1:2) = 0;
n = 1;
N = 1;
BB = D;
for ii = 1 : EQ64
	for jj = 1 : EQ256 %#ok<ALIGN>
        hnn = 1;
        i = ii;
        j = jj;
        flag = 0; %first IN from this point
        while ( hnn > 0 )
            if flag %if not first times in while
                i = K(hnn,1);
                j = K(hnn,2);
            end;
            flag = 1;          

            if ( j <= EQ256 && i <= EQ64 && G(i,j) == 0 && D(i,j) > 0 )
            	
                F(n,1) = n;
                F(n,2) = F(n,2) + C(i,j);                
                F(n,3) = F(n,3) + j*C(i,j);
            	F(n,4) = F(n,4) + (i - EQ64/2)*C(i,j);                
            	F(n,5) = F(n,5) + E(i,j)*C(i,j);
                F(n,6) = F(n,6) + 1; %dont need
                
            	G(i,j) = 1;
            	H(i,j) = 0;
            	BB(i,j) = n;                
                hnn = hnn - 1;
                
            	if ( j + 1 <= EQ256 && G(i, j+1) == 0 && D(i, j+1) > 0 ) %#ok<ALIGN>
                	H(i,j+1) = 1;
                    hnn = hnn + 1;
                    K(hnn,1) = i;
                    K(hnn,2) = j+1;
                end;

                if ( j - 1 >= 1 && G(i, j-1) == 0 && D(i, j-1) > 0 )
                	H(i,j-1) = 1;
                    hnn = hnn + 1; 
                    K(hnn,1) = i;
                    K(hnn,2) = j-1;
                end;

                if ( i + 1 <= EQ64 && G(i+1, j) == 0 && D(i+1, j) > 0 )
                	H(i+1,j) = 1;
                    hnn = hnn + 1; 
                    K(hnn,1) = i+1;
                    K(hnn,2) = j;
                end;

                if ( i - 1 >= 1 && G(i-1, j) == 0 && D(i-1, j) > 0 )
                	H(i-1,j) = 1;
                    hnn = hnn + 1; 
                    K(hnn,1) = i-1;
                    K(hnn,2) = j;
               	end;
            else
                break;
            end;
        end;
        if (F(n,2) > 0)
        	n = n + 1;
        end;
    end;
end;

for i = 1:int32(EQ64*EQ256/2)
	if (F(n,2) > 0)
        F(i,3) = F(i,3)/F(i,2);
        F(i,4) = F(i,4)/F(i,2);
        F(i,5) = F(i,5)/F(i,2);
	end;
end;
