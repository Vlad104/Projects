clear
EQ256 = 256; % число, эквивалентное 256
EQ64 = 64; % число, эквивалентное 64
%Rd = 3;  %разрешение по дальности
%Vd = 0.78125; %разрешение по скорости

% запись двух входных сигналов с двух каналов
% на вход fft [EQ256][EQ64]
% в такой записи fft делается по столбцам
% на выходе fft [EQ256][EQ64]
[BufferIn1, BufferIn2, Rd, Vd] = signal_target1(EQ64, EQ256);

% БПФ с прореживанием по времени
BufferFFTt1 = fft(BufferIn1);
BufferFFTt2 = fft(BufferIn2);

%отсечка симметричной части
%преобразуем [256][64] в [128][64]
BufferFFTt1(EQ256/2+1:EQ256,:) = [];
BufferFFTt2(EQ256/2+1:EQ256,:) = [];

% операция транспонирования матрицы
BufferFFTt1 = BufferFFTt1';
BufferFFTt2 = BufferFFTt2';

% БПФ с прореживанием по частоте    
BufferFFTw1 = fft(BufferFFTt1);
BufferFFTw2 = fft(BufferFFTt2);

% расчет мощности в каждой точке (сумма модулей соответствующих двух чисел)
energy0 = abs(BufferFFTw1) + abs(BufferFFTw2);
% преобразование матрица дальность-скорость к "привычному" виду
%energy1 = energy0;
energy1(1:1:32,:) = energy0(32:-1:1,:);
energy1(33:1:64,:) = energy0(64:-1:33,:);

k = 6; % коэффициент порога
n_look = 10; % колличество обозреваемых точек 
n_miss = 2; % колличество пропускаемых точек 

% пороговая фильтрация
energy = threshold_filter(energy1, k, EQ64, EQ256/2, n_look, n_miss);

% расчет угла
%arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);
arg = argument1(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256/2);

% кластеризация и заполнение структуры
% нулевая скорость в 32 строке energy -> 64 строка неинформативна
Struct = clustering(energy, energy1, arg, Rd, Vd, EQ64, EQ256/2);

    ax = Rd:Rd:128*Rd;
    ay = -31*Vd:Vd:32*Vd;
%     %[X,Y] = meshgrid(ax ,ay);
    %surfc(X,Y,energy1);
%    surfc(energy1);
    image(ax,ay, energy1, 'CDataMapping' , 'scaled' )
    %image(BufferIn1', 'CDataMapping' , 'scaled' )
    hold on
%     %image(energy1, 'CDataMapping' , 'scaled' );
    title('Матрица дальность - скорость');
    %title(['Номер кадра: ', num2str(F)]);
    xlabel('Дальность, м');
    ylabel('Относительная скорость, м/с');
    zlabel('Мощность');
    pause(0.1)
    %W(F,:,:) = energy1;
    %SS(F) = Struct;
