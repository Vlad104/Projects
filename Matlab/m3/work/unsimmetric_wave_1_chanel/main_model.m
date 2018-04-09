% ������� ���������� ����������
clear
EQ64  = 64;
EQ256 = 256;
RN    = 50;
R  = [100]; 
V  = [10];
fi = [19];

% ����������� � �������� �������
[s0_cos, s0_sin, sL_rx, sR_rx] = signal(R, V, fi, EQ64, EQ256);
L = length(sL_rx); % ���-�� ��������

% ������� �� ������ ���������
sL_sm(1:EQ64,1:L) = 0;
sR_sm(1:EQ64,1:L) = 0;
sL_sm_cos(1:EQ64,1:L) = 0;
sR_sm_cos(1:EQ64,1:L) = 0;
sL_sm_sin(1:EQ64,1:L) = 0;
sR_sm_sin(1:EQ64,1:L) = 0;
for i = 1:EQ64
    sL_sm_cos(i, :) = s0_cos(i,:).*sL_rx(i,:);
    sR_sm_cos(i, :) = s0_cos(i,:).*sR_rx(i,:);
    sL_sm_sin(i, :) = s0_sin(i,:).*sL_rx(i,:);
    sR_sm_sin(i, :) = s0_sin(i,:).*sR_rx(i,:);
    sL_sm(i, :) = sL_sm_cos(i, :);
    sR_sm(i, :) = sR_sm_cos(i, :);    
%     sL_sm(i, :) = sqrt(sL_sm_cos(i, :).^2 + sL_sm_sin(i, :).^2);
%     sR_sm(i, :) = sqrt(sR_sm_cos(i, :).^2 + sR_sm_sin(i, :).^2);    
end;

% ���, fc = 1MHz
sL_lpf(1:EQ64,1:L) = 0;
sR_lpf(1:EQ64,1:L) = 0;
[b,a] = butter(2,1e6/8e8,'low');
for i = 1:EQ64
    sL_lpf(i,:) = filter(b,a,sL_sm(i,:)); 
    sR_lpf(i,:) = filter(b,a,sR_sm(i,:)); 
end;

% ������������� �������
sL(1:EQ64,1:EQ256) = sL_lpf(1:EQ64,1:round(L/EQ256):L);
sR(1:EQ64,1:EQ256) = sR_lpf(1:EQ64,1:round(L/EQ256):L);

% ���
sL_hps(1:EQ64,1:256) = 0;
sR_hps(1:EQ64,1:256) = 0;
[b,a] = butter(1, 1e6/(EQ256*8000), 'high'); 
for i = 1:EQ64
    sL_hps(i,:) = filter(b,a,sL(i,:));
    sR_hps(i,:) = filter(b,a,sR(i,:));
end;

% ������� � ����� ��������
BufIn1(1:EQ64,1:EQ256) = 0;
BufIn2(1:EQ64,1:EQ256) = 0;
w1=hamming(EQ256)';	% ���� ��������
for i=1:EQ64
	BufIn1(i,:) = sL_hps(i,:).*w1;
	BufIn2(i,:) = sR_hps(i,:).*w1;
end;

% ��� �� �������� ������� (�� ������� �������)
BufFFT_t1(1:EQ64,1:EQ256) = 0;
BufFFT_t2(1:EQ64,1:EQ256) = 0;
for i=1:EQ64
    BufFFT_t1(i,:) = fft(BufIn1(i,:));
    BufFFT_t2(i,:) = fft(BufIn2(i,:));
end;

% ������� ������������ �����
% ����������� [256][64] � [50][64]
BufFFT_t1(:,RN+1:EQ256) = [];
BufFFT_t2(:,RN+1:EQ256) = [];

% ������� � ����� ��������
w2=hamming(EQ64);	% ���� ��������
for i=1:RN
	BufIn1(:,i) = sL_hps(:,i).*w2;
	BufIn2(:,i) = sR_hps(:,i).*w2;
end;

% ��� �� ���������� ������� (�� ����������� ��������)
BufFFT_w1 = fft(BufFFT_t1);
BufFFT_w2 = fft(BufFFT_t2);

% ������ �������� � ������ ����� (����� ������� ��������������� ���� �����
W0 = abs(BufFFT_w1) + abs(BufFFT_w2);

% �������������� ������� ���������-�������� � ������������ ����
W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);

W = detector_const_threshold(W1, 200, EQ64, RN);
%W = detector(W1, EQ64, RN);

arg = peleng_angle(W, BufFFT_w1, BufFFT_w2, EQ64, RN);

% ���������
Rd = 3;
Vd = 0.78125;
ax = Rd:Rd:RN*Rd;    
ay = -31*Vd:Vd:32*Vd;
%colormap(winter);
subplot(1,3,1); pcolor(ax,ay, W1);
subplot(1,3,2); pcolor(ax,ay, W);
subplot(1,3,3); pcolor(ax,ay, arg);
arg(19,34)
