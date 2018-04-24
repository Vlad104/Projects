function W = detector(X, EQ64, RN)
    F = 10e-8;  
    W = X; 
    
    for i = 1:EQ64
        sigma = std(X(i,:));
        E = sigma*sqrt(-2*log(F));
        for j = 1:RN
            if X(i,j) > E
                W(i,j) = X(i,j);
            else
                W(i,j) = 0;                
            end;
        end;
    end;
end