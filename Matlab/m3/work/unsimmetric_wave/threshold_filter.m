function energy = threshold_filter(energy0, k, EQ64, EQ256, n_look, n_miss)
%	функция пороговой фильтрации входной матрицы
%   вход:
%       - energy0 - матрица EQ64хEQ256 значений мощности в каждой точке
%       - k - пороговый коэффициен, подбирается эксперементальным методом
%       - EQ256 и EQ64 - эквиваленты чисел 256 и 64 соответственно
%       - n_look - число точек для расчета среднего значения
%       - n_miss - число отступаемых точек
%   выход:
%       - energy - матрица EQ64хEQ256 значений мощности в точках, со
%         значением выше порога и 0 в точках ниже порога

    %инициализация переменных %%
    energy(1:EQ64, 1:EQ256) = 0; % создание массива с нулями
    n = n_look + n_miss;
    temp(1:EQ64+2*n) = 0;
    
    for i = 1:EQ64
        temp(1:n) = 0; % = energy0(n+1:);
        temp(n+1:EQ256+n) = energy0(i,1:EQ256);
        temp(EQ256+n+1:EQ256+2*n) = 0; % = energy0(i,1:n);
        for j = n+1:EQ256+n
            S1 = 0;
            S2 = 0;
            for z = 1:n_look
                S1 = S1 + temp(j+n_miss+z); 
                S2 = S2 + temp(j-n_miss-z); 
            end;
            S1 = S1/n_look;
            S2 = S2/n_look;
            if ( j >= n+1 && j <= EQ256+n && temp(j) > k*S1 && temp(j) > k*S2 )
                energy(i,j-n) = temp(j);
            else
                energy(i,j-n) = 0;
            end;                
        end;      
    end;
end