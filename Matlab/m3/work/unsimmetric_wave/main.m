clear
EQ256 = 256; % �����, ������������� 256
EQ64 = 64; % �����, ������������� 64
%Rd = 3;  %���������� �� ���������
%Vd = 0.78125; %���������� �� ��������

%������������� ������
% BufferIn1(1:256,1:64) = 0;
% BufferIn2(1:256,1:64) = 0;
% BufferFFTt1(1:256,1:64) = 0;
% BufferFFTt2(1:256,1:64) = 0;
% BufferFFTw1(1:64,1:128) = 0;
% BufferFFTw2(1:64,1:128) = 0;
% energy0(1:64,1:128) = 0;
% energy(1:64,1:128) = 0;

 % ������ ���� ������� �������� � ���� �������
 % �� ���� fft [EQ256][EQ64]
 % � ����� ������ fft �������� �� ��������
 % �� ������ fft [EQ256][EQ64]
[BufferIn1, BufferIn2, Rd, Vd] = signal_target1(EQ64, EQ256);

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
energy1(1:1:32,:) = energy0(32:-1:1,:);
energy1(33:1:64,:) = energy0(64:-1:33,:);

k = 6; % ����������� ������

% ��������� ����������
energy = filtering(energy1, k, EQ64, EQ256/2);

% ������ ����
arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);

% ������������� � ���������� ���������
Struct = clustering(energy, energy0, arg, Rd, Vd, EQ64, EQ256/2);
