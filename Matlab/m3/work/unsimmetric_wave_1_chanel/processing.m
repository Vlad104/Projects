function W2 = processing(BufIn1, BufIn2, EQ64, EQ256, RN)

    % ФВЧ
    sL_hps(1:EQ64,1:256) = 0;
    sR_hps(1:EQ64,1:256) = 0;
    [b,a] = butter(1, 1e6/200e6, 'high'); 
    for i = 1:EQ64
        sL_hps(i,:) = filter(b,a,sL(i,:));
        sR_hps(i,:) = filter(b,a,sR(i,:));
    end;

    % свертка с окном Хэмминга
    BufIn1(1:EQ64,1:EQ256) = 0;
    BufIn2(1:EQ64,1:EQ256) = 0;
    w1=hamming(EQ256);	% окно Хэмминна
    for i=1:EQ64
        BufIn1(i,:) = sL_hps(i,:).*w1';
        BufIn2(i,:) = sR_hps(i,:).*w1';
    end;

    % БПФ по медленному времени (по строкам)
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
    for i=1:EQ256/2
        BufIn1(:,i) = sL_hps(:,i).*w2;
        BufIn2(:,i) = sR_hps(:,i).*w2;
    end;

    % БПФ по быстрому времени (по столбцам)
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);

    % расчет мощности в каждой точке (сумма модулей соответствующих двух чисел
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    % преобразование матрица дальность-скорость к стандартному виду
    W2(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W2(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
end;
