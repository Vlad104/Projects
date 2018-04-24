function W3 = processing_withCorrection(sL_bad, sR_bad, EQ64, EQ256, RN)
    
    x = 1:EQ256;
    coeff1 = polyfit(x, sL_bad(1,:), 2); %апроскимация полиномом 2-го порядка
    coeff2 = polyfit(x, sR_bad(1,:), 2);
    
    for i=1:EQ64 %компенсация ПАМ
        sL_bad(i,:) = sL_bad(i,:) - polyval(coeff1, x);
        sR_bad(i,:) = sR_bad(i,:) - polyval(coeff2, x);
    end;
    
    % медианный фильтр
    sL(1:EQ64,1:EQ256) = 0;
    sR(1:EQ64,1:EQ256) = 0;
    for i = 1:EQ64
        sL(i,:) = medfilt2(sL_bad(i,:),[1 5]);
        sR(i,:) = medfilt2(sR_bad(i,:),[1 5]);
    end;    

    % фильтр какой-то
    [b1,a1]=butter(6,0.5);    
    for i=1:EQ64
        sL(i,:) = filter(b1,a1,sL_bad(i,:));
        sR(i,:) = filter(b1,a1,sR_bad(i,:));
    end;
    
    % ФВЧ
    sL_hps(1:EQ64,1:256) = 0;
    sR_hps(1:EQ64,1:256) = 0;    
    fdd = 256*8000;
    fnn = fdd/2; %частота Найквиста
    [b,a] = butter(1, 4e5/fnn, 'high'); 
    for i = 1:EQ64
        sL_hps(i,:) = filter(b,a,sL(i,:));
        sR_hps(i,:) = filter(b,a,sR(i,:));
    end;

    % свертка с окном Хэмминга
    BufIn1(1:EQ64,1:EQ256) = 0;
    BufIn2(1:EQ64,1:EQ256) = 0;
    w1=hamming(EQ256)';	% окно Хэмминна
    for i=1:EQ64
        BufIn1(i,:) = sL_hps(i,:).*w1;
        BufIn2(i,:) = sR_hps(i,:).*w1;
    end;

    % БПФ по быстрому времени (по строкам)
    BufFFT_t1(1:EQ64,1:EQ256) = 0;
    BufFFT_t2(1:EQ64,1:EQ256) = 0;
    for i=1:EQ64
        BufFFT_t1(i,:) = fft(BufIn1(i,:));
        BufFFT_t2(i,:) = fft(BufIn2(i,:));
    end;

    % отсечка симметричной части
    % преобразуем [256][64] в [50][64]
    BufFFT_t1(:,RN+1:EQ256) = [];
    BufFFT_t2(:,RN+1:EQ256) = [];

    % свертка с окном Хэмминга
    w2=hamming(EQ64);	% окно Хэмминна
    for i=1:RN
        BufIn1(:,i) = sL_hps(:,i).*w2;
        BufIn2(:,i) = sR_hps(:,i).*w2;
    end;

    % БПФ по быстрому времени (по столбцам)
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);

    % расчет мощности в каждой точке (сумма модулей соответствующих двух чисел
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    
    % преобразование матрица дальность-скорость к стандартному виду
    W3(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W3(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
end
