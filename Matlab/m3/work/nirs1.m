clear
EQ256 = 256; % число, эквивалентное 256
EQ64 = 64; % число, эквивалентное 64

 % запись двух входных сигналов (тк две антенны)
[BufferIn1, BufferIn2] = signal(EQ64, EQ256);

% БПФ с прореживанием по времени
BufferFFTt1 = fft(BufferIn1(:,:));
BufferFFTt2 = fft(BufferIn2(:,:));

% операция транспонирования матрицы
BufferFFTt1 = BufferFFTt1';
BufferFFTt2 = BufferFFTt2';

% БПФ с прореживанием по частоте    
BufferFFTw1 = fft(BufferFFTt1(:,:));
BufferFFTw2 = fft(BufferFFTt2(:,:));

%расчет мощности в каждой точке (сумма модулей соответствующих двух чисел)
energy0 = abs(BufferFFTw1) + abs(BufferFFTw2);

k = 1; % коэффициент порога

% адаптивная пороговая фильтрация
energy = adaptive_filtering(energy0, k, EQ64, EQ256);

% расчет угла
angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256);

% кластеризация и заполнение структуры
%Struct = clustering(energy, energy0, angle, EQ64, EQ256);
[Struct,MAT] = clustering(energy, energy0, angle, EQ64, EQ256);
