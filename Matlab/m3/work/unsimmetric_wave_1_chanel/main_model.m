% задание начальныйх параметров
clear
EQ64  = 64;
EQ256 = 256;
RN    = 50;
R  = [50, 100]; 
V  = [10, -10];
fi = [10, 45];

% зондирующий и принятые сигналы
[s0, sL_rx, sR_rx] = signal(R, V, fi, EQ64, EQ256);
L = length(sL_rx); % кол-во отсчетов

% сигналы на выходе смесителя
sL_sm(1:EQ64,1:L) = 0;
sR_sm(1:EQ64,1:L) = 0;
for i = 1:EQ64
    sL_sm(i, :) = s0(i,:).*sL_rx(i,:);
    sR_sm(i, :) = s0(i,:).*sR_rx(i,:);
end;

% ФНЧ, fc = 1MHz
sL_lpf(1:EQ64,1:L) = 0;
sR_lpf(1:EQ64,1:L) = 0;
[b,a] = butter(2,1e6/8e8,'low');
for i = 1:EQ64
    sL_lpf(i,:) = filter(b,a,sL_sm(i,:)); 
    sR_lpf(i,:) = filter(b,a,sR_sm(i,:)); 
end;

% дискретизация сигнала
sL(1:EQ64,1:EQ256) = sL_lpf(1:EQ64,1:round(L/EQ256):L);
sR(1:EQ64,1:EQ256) = sR_lpf(1:EQ64,1:round(L/EQ256):L);

% ФВЧ
sL_hps(1:EQ64,1:256) = 0;
sR_hps(1:EQ64,1:256) = 0;
[b,a] = butter(1, 1e6/(EQ256*8000), 'high'); 
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

% БПФ по быстрому времени (по периоду сигнала)
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

% БПФ по медленному времени (по накомленным периодам)
BufFFT_w1 = fft(BufFFT_t1);
BufFFT_w2 = fft(BufFFT_t2);

% расчет мощности в каждой точке (сумма модулей соответствующих двух чисел
W0 = abs(BufFFT_w1) + abs(BufFFT_w2);

% преобразование матрица дальность-скорость к стандартному виду
W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);

% отрисовка
Rd = 3;
Vd = 0.78125;
ax = Rd:Rd:RN*Rd;    
ay = -31*Vd:Vd:32*Vd;
%colormap(jet);
pcolor(ax,ay, W1);
