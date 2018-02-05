clear
id1 = fopen('C:\Users\Ignat\Desktop\SVN\qq_left.dat','r');
id2 = fopen('C:\Users\Ignat\Desktop\SVN\qq_right.dat','r');
f1=fread(id1,'float');
f2=fread(id2,'float');

k = 100000000;

for i = 1:64
    for j = 1:256
        ss1(i,j) = f1(k);
        ss2(i,j) = f2(k);
        k = k + 1;
    end;
end;

EQ256 = 256; % число, эквивалентное 256
EQ64 = 64; % число, эквивалентное 64
Rd = 3;  %разрешение по дальности
Vd = 0.78125; %разрешение по скорости
BufferIn1 = ss1';
BufferIn2 = ss2';

BufferFFTt1 = fft(BufferIn1);
BufferFFTt2 = fft(BufferIn2);


BufferFFTt1(EQ256/2+1:EQ256,:) = [];
BufferFFTt2(EQ256/2+1:EQ256,:) = [];

BufferFFTt1 = BufferFFTt1';
BufferFFTt2 = BufferFFTt2';

BufferFFTw1 = fft(BufferFFTt1);
BufferFFTw2 = fft(BufferFFTt2);

energy0 = abs(BufferFFTw1) + abs(BufferFFTw2);

k = 6; % коэффициент порога

% адаптивная пороговая фильтрация
energy = adaptive_filtering(energy0, k, EQ64, EQ256/2);

% расчет угла
angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256/2);

% кластеризация и заполнение структуры
Struct = clustering(energy, energy0, angle, Rd, Vd, EQ64, EQ256/2);