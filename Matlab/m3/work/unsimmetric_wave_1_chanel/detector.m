function W = detector(X, EQ64, RN)
    W = X; 
    F = 10e-8;
    sigma = 280;
    sigma = 3*sigma;
    E = sigma*sqrt(-2*log(F));
    
    for i = 1:EQ64
        for j = 1:RN
            if X(i,j) > E
                W(i,j) = X(i,j);
            else
                W(i,j) = 0;                
            end;
        end;
    end;
end