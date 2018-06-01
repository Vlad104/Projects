function E = calculate_threshold(W1, F)

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

    i = 1;
    while ( F < ( 1 - sum(G(1:i))))
        i = i+1;
    end;
    E = i * C;
    
end