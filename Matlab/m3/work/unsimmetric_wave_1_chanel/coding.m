clear W0 W1 A B C D E F G

W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    
% преобразование матрица дальность-скорость к стандартному виду
W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);

A = W1(1,:);
B = sort(A);

C = max(B) - min(B);
C = C/length(B)*10;
K = round(max(B)/C);
D(1:50) = 0;
i = 1;
j = 1;
k = 0;
for i = 1:50
    while ( j <= 50 && B(j) < C*i )
        j = j + 1;
        k = k + 1;
    end;
    D(i) = k;
    k = 0;
end;


%G = interp1(1:length(B), D, 1:0.01:length(B), 'cubic');
E = D/length(D);

F = 10e-3;
P = 0;
i = 1;
while ( F < ( 1 - sum(E(1:i))))
    i = i+1;
end;
E = i * C;
