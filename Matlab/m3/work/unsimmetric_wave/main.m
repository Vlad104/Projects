clear

EQ256 = 256;      % число, эквивалентное 256
EQ128 = EQ256/2;  % число, эквивалентное 256/2
EQ64 = 64;        % число, эквивалентное 64

Rd = 3;  %разрешение по дальности
Vd = 0.78125; %разрешение по скорости

% запись двух входных сигналов с двух каналов
% на вход fft матрица размерности [EQ256][EQ64]
% в такой записи fft делается по столбцам
% на выходе результат fft размерности [EQ256][EQ64]
%[sL, sR, Rd, Vd] = signal_target1(EQ64, EQ256);
%len = 1;

frames_full = load('C:\Users\Ignat\Desktop\DATAS\НАМИ\3\radar\nami3_2017_05_26__10_46_32.mat'); 
frames = frames_full.Array_of_data();
len=length(frames(1,:)); %размер данных

for F = 1:len
    sL  = double(frames(F).data_1canal); % 64*256 с левого канала
    sR  = double(frames(F).data_2canal);  % 64*256 с правого канала
    sL = sL';
    sR = sR';
    
    [W1,BufFFT_w1,BufFFT_w2] = processing(sL, sR, EQ256, EQ64);
    W2 = correction(sL, sR, EQ256, EQ64);
    W3 = no_filter(sL, sR, EQ256, EQ64);


    k = 6; % коэффициент порога
    n_look = 10; % колличество обозреваемых точек 
    n_miss = 2; % колличество пропускаемых точек

    % пороговая фильтрация
    W = threshold_filter(W1, k, EQ64, EQ256/2, n_look, n_miss);

    % расчет угла
    %arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);
    arg = argument_amp(BufFFT_w1, BufFFT_w2, W, EQ64, EQ256/2);

    % кластеризация и заполнение структуры
    % нулевая скорость в 32 строке energy -> 64 строка неинформативна
    Struct = clustering(W, W1, arg, Rd, Vd, EQ64, EQ256/2);

    %координатная сетка для построения графиков
    ax = Rd:Rd:128*Rd;    
    ay = -31*Vd:Vd:32*Vd;

    colormap(jet);
    subplot(1,3,1);pcolor(ax,ay, W1);
    subplot(1,3,2);pcolor(ax,ay, W2);
    subplot(1,3,3);pcolor(ax,ay, W3);
    F
    %title(['Номер кадра: ', num2str(F)]);
    %xlabel('Дальность, м');
    %ylabel('Относительная скорость, м/с');
    %zlabel('Мощность');   
    
    pause(0.1);
end
