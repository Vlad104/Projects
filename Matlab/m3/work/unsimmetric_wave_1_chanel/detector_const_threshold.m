function W = detector_const_threshold(W1, k, EQ64, RN)
    W = W1;
    for i = 1:EQ64
        for j = 1:RN
            if W1(i,j) < k
                W(i,j) = 0;
            end;
        end;
    end;
end