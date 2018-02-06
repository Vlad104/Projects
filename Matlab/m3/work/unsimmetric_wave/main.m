clear
EQ256 = 256; % число, эквивалентное 256
EQ64 = 64; % число, эквивалентное 64
%Rd = 3;  %разрешение по дальности
%Vd = 0.78125; %разрешение по скорости

%инициализация матриц
% BufferIn1(1:256,1:64) = 0;
% BufferIn2(1:256,1:64) = 0;
% BufferFFTt1(1:256,1:64) = 0;
% BufferFFTt2(1:256,1:64) = 0;
% BufferFFTw1(1:64,1:128) = 0;
% BufferFFTw2(1:64,1:128) = 0;
% energy0(1:64,1:128) = 0;
% energy(1:64,1:128) = 0;

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
energy1(1:1:32,:) = energy0(32:-1:1,:);
energy1(33:1:64,:) = energy0(64:-1:33,:);

k = 6; % коэффициент порога

% пороговая фильтрация
energy = filtering(energy1, k, EQ64, EQ256/2);

% расчет угла
arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);

% кластеризация и заполнение структуры
Struct = clustering(energy, energy0, arg, Rd, Vd, EQ64, EQ256/2);
