clear W0 W1 A B C D E F G

W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    
% �������������� ������� ���������-�������� � ������������ ����
W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);


%function E = threshold(W1)

    W11 = W1(1,:);
    B = sort(W11);
    steps = 7;

    C = max(B) - min(B);
    C = C/length(B)*steps;
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


    G = D/length(D);
    GI = interp1(1:length(G), G, 1:1/C:length(G), 'cubic');

    F = 10e-3;
    P = 0;
    i = 1;
    while ( F < ( 1 - sum(G(1:i))))
        i = i+1;
    end;
    E = i * C;
%end