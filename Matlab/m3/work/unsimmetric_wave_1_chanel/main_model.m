% ������� ���������� ����������
clear
EQ64  = 64;
EQ256 = 256;
RN    = 50;
R  = [100]; 
V  = [-5];
fi = [45];

% ����������� � �������� �������
[s0, s1_rx, s2_rx] = signal(R, V, fi, EQ64, EQ256);
L = length(s1_rx); % ���-�� ��������

% ������� �� ������ ���������
s1_sm(1:EQ64,1:L) = 0;
s2_sm(1:EQ64,1:L) = 0;
for i = 1:EQ64
    s1_sm(i, :) = s0(i,:).*s1_rx(i,:);
    s2_sm(i, :) = s0(i,:).*s2_rx(i,:);
end;

% ���, fc/fd = 1���/200���
s1_lpf(1:EQ64,1:L) = 0;
s2_lpf(1:EQ64,1:L) = 0;
[b,a] = butter(2,0.02,'low');
for i = 1:EQ64
    s1_lpf(i,:) = filter(b,a,s1_sm(i,:)); 
    s2_lpf(i,:) = filter(b,a,s2_sm(i,:)); 
end;

% ������������� �������
sL(1:EQ64,1:EQ256) = s1_lpf(1:EQ64,1:round(L/EQ256):L);
sR(1:EQ64,1:EQ256) = s2_lpf(1:EQ64,1:round(L/EQ256):L);

% ���
sL_hps(1:EQ64,1:256) = 0;
sR_hps(1:EQ64,1:256) = 0;
[b,a] = butter(1, 1e6/200e6, 'high'); 
for i = 1:EQ64
    sL_hps(i,:) = filter(b,a,sL(i,:));
    sR_hps(i,:) = filter(b,a,sR(i,:));
end;

% ������� � ����� ��������
BufIn1(1:EQ64,1:EQ256) = 0;
BufIn2(1:EQ64,1:EQ256) = 0;
w1=hamming(EQ256);	% ���� ��������
for i=1:EQ64
	BufIn1(i,:) = sL_hps(i,:).*w1';
	BufIn2(i,:) = sR_hps(i,:).*w1';
end;

% ��� �� ���������� ������� (�� �������)
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
for i=1:EQ256/2
	BufIn1(:,i) = sL_hps(:,i).*w2;
	BufIn2(:,i) = sR_hps(:,i).*w2;
end;

% ��� �� �������� ������� (�� ��������)
BufFFT_w1 = fft(BufFFT_t1);
BufFFT_w2 = fft(BufFFT_t2);

% ������ �������� � ������ ����� (����� ������� ��������������� ���� �����
W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
% �������������� ������� ���������-�������� � ������������ ����
W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);


% ���������
Rd = 3;
Vd = 0.78125;
ax = Rd:Rd:RN*Rd;    
ay = -31*Vd:Vd:32*Vd;
colormap(jet);
pcolor(ax,ay, W1);
