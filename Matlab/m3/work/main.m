clear
EQ256 = 256; % число, эквивалентное 256
EQ64 = 64; % число, эквивалентное 64

 % запись двух входных сигналов с двух каналов
 % на вход fft [EQ256][EQ64]
 % в такой записи fft делается по столбцам
 % на выходе fft [EQ256][EQ64]
[BufferIn1, BufferIn2] = signal_target4(EQ64, EQ256);

% БПФ с прореживанием по времени
BufferFFTt1 = fft(BufferIn1);
BufferFFTt2 = fft(BufferIn2);

%отсечка симметричной части
%преобразуем [64][256] в [64][128]
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

k = 6; % коэффициент порога

% адаптивная пороговая фильтрация
energy = adaptive_filtering(energy0, k, EQ64, EQ256/2);

% расчет угла
angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256/2);

% кластеризация и заполнение структуры
Struct = clustering(energy, energy0, angle, EQ64, EQ256/2);
% [Struct,MAT] = clustering(energy, energy0, angle, EQ64, EQ256);

surfc(energy); % построение 3D графика распределения мощностей
title('Цели');
xlabel('Дальность');
ylabel('Скорость');
