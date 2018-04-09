function W = detector(W1, EQ64, RN)
    F = 10e-3;
    sigma = 0.1;
    
    X0 = sigma*sqrt(-2*log(F));     
    
    W = W1;
    for i = 1:EQ64
        for j = 1:RN
            if W1(i,j) > X0
                W(i,j) = 1;
            else
                W(i,j) = 0;                
            end;
        end;
    end;
end