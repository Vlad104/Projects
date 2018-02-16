load('C:\Users\Ignat\Desktop\DATAS\����\3\radar\nami3_2017_05_26__12_29_13.mat');
frames = Array_of_data(741:1155);

F = 415; 
ss1 = double(frames(F).data_1canal);
ss2 = double(frames(F).data_2canal);

EQ256 = 256; % �����, ������������� 256
EQ64 = 64; % �����, ������������� 64
Rd = 3;  %���������� �� ���������
Vd = 0.78125; %���������� �� ��������
BufferIn1 = ss1';
BufferIn2 = ss2';

% ��� � ������������� �� �������
BufferFFTt1 = fft(BufferIn1);
BufferFFTt2 = fft(BufferIn2);

%������� ������������ �����
%����������� [256][64] � [128][64]
BufferFFTt1(EQ256/2+1:EQ256,:) = [];
BufferFFTt2(EQ256/2+1:EQ256,:) = [];

% �������� ���������������� �������
BufferFFTt1 = BufferFFTt1';
BufferFFTt2 = BufferFFTt2';

% ��� � ������������� �� �������    
BufferFFTw1 = fft(BufferFFTt1);
BufferFFTw2 = fft(BufferFFTt2);

% ������ �������� � ������ ����� (����� ������� ��������������� ���� �����)
energy0 = abs(BufferFFTw1) + abs(BufferFFTw2);
% �������������� ������� ���������-�������� � "����������" ����
energy1(1:1:32,:) = energy0(32:-1:1,:);
energy1(33:1:64,:) = energy0(64:-1:33,:);

k = 6; % ����������� ������
n_look = 10; % ����������� ������������ ����� 
n_miss = 2; % ����������� ������������ ����� 

% ��������� ����������
energy = threshold_filter(energy1, k, EQ64, EQ256/2, n_look, n_miss);

% ������ ����
arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);

% ������������� � ���������� ���������
% ������� �������� � 32 ������ energy -> 64 ������ ��������������
Struct = clustering(energy, energy1, arg, Rd, Vd, EQ64, EQ256/2);


[X,Y] = meshgrid(1*Rd:Rd:128*Rd ,-31*Vd:Vd:32*Vd);
surfc(X,Y,energy1)
%title('������� ��������� - ��������');
title(F);
xlabel('���������, �');
ylabel('������������� ��������, �/�');
zlabel('��������');
