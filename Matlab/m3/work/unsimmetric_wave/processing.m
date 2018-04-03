    function [W1,BufFFT_w1,BufFFT_w2] = processing(sL, sR, EQ256, EQ64, RN)

    BufIn1(1:256,1:64) = 0;
    BufIn2(1:256,1:64) = 0; 
    
    %значения коэффициентов фильтра
%     a = [0.92703707226149745000, -0.92703707226149745000];
%     b = [1.00000000000000000000, -0.85408068546991278000];
    [a,b] = butter(1, 1e6/3e6, 'high');
    
    sL_f = filter(a,b,sL);
    sR_f = filter(a,b,sR);

    w1=hamming(EQ256); %окно Хэмминна
    %свертка с окном Хэмминга
    for i=1:EQ256
        for j=1:EQ64
            BufIn1(i,j) = sL_f(i,j)*w1(i);
            BufIn2(i,j) = sR_f(i,j)*w1(i);
        end;
    end;

   % БПФ по быстрому времени
    BufFFT_t1 = fft(BufIn1);
    BufFFT_t2 = fft(BufIn2);
    
    %отсечка симметричной части
    %преобразуем [256][64] в [50][64]
    BufFFT_t1(RN+1:EQ256,:) = [];
    BufFFT_t2(RN+1:EQ256,:) = [];

    % операция транспонирования матрицы
    BufFFT_t1 = BufFFT_t1';
    BufFFT_t2 = BufFFT_t2';

    w2=hamming(EQ64); %окно Хэмминна
    %свертка с окном Хэмминга
    for i=1:EQ64
        for j=1:RN
            BufFFT_t1(i,j) = BufFFT_t1(i,j).*w2(i);
            BufFFT_t2(i,j) = BufFFT_t2(i,j).*w2(i);
        end;
    end;

    % БПФ по медленному времени
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);
    
    % расчет мощности в каждой точке (сумма модулей соответствующих двух чисел)
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    % преобразование матрица дальность-скорость к стандартному виду
    W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
    
end