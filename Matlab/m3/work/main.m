clear
EQ256 = 256; % �����, ������������� 256
EQ64 = 64; % �����, ������������� 64

 % ������ ���� ������� �������� � ���� �������
 % �� ���� fft [EQ256][EQ64]
 % � ����� ������ fft �������� �� ��������
 % �� ������ fft [EQ256][EQ64]
[BufferIn1, BufferIn2] = signal_target4(EQ64, EQ256);

% ��� � ������������� �� �������
BufferFFTt1 = fft(BufferIn1);
BufferFFTt2 = fft(BufferIn2);

%������� ������������ �����
%����������� [64][256] � [64][128]
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

k = 6; % ����������� ������

% ���������� ��������� ����������
energy = adaptive_filtering(energy0, k, EQ64, EQ256/2);

% ������ ����
angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256/2);

% ������������� � ���������� ���������
Struct = clustering(energy, energy0, angle, EQ64, EQ256/2);
% [Struct,MAT] = clustering(energy, energy0, angle, EQ64, EQ256);

surfc(energy); % ���������� 3D ������� ������������� ���������
title('����');
xlabel('���������');
ylabel('��������');
