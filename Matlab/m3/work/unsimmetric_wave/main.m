clear
EQ256 = 256; % �����, ������������� 256
EQ64 = 64; % �����, ������������� 64
%Rd = 3;  %���������� �� ���������
%Vd = 0.78125; %���������� �� ��������

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
% �������������� ������� ���������-�������� � "����������" ����
%energy1 = energy0;
energy1(1:1:32,:) = energy0(32:-1:1,:);
energy1(33:1:64,:) = energy0(64:-1:33,:);

k = 6; % ����������� ������
n_look = 10; % ����������� ������������ ����� 
n_miss = 2; % ����������� ������������ ����� 

% ��������� ����������
energy = threshold_filter(energy1, k, EQ64, EQ256/2, n_look, n_miss);

% ������ ����
%arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);
arg = argument1(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256/2);

% ������������� � ���������� ���������
% ������� �������� � 32 ������ energy -> 64 ������ ��������������
Struct = clustering(energy, energy1, arg, Rd, Vd, EQ64, EQ256/2);

    ax = Rd:Rd:128*Rd;
    ay = -31*Vd:Vd:32*Vd;
%     %[X,Y] = meshgrid(ax ,ay);
    %surfc(X,Y,energy1);
%    surfc(energy1);
    image(ax,ay, energy1, 'CDataMapping' , 'scaled' )
    %image(BufferIn1', 'CDataMapping' , 'scaled' )
    hold on
%     %image(energy1, 'CDataMapping' , 'scaled' );
    title('������� ��������� - ��������');
    %title(['����� �����: ', num2str(F)]);
    xlabel('���������, �');
    ylabel('������������� ��������, �/�');
    zlabel('��������');
    pause(0.1)
    %W(F,:,:) = energy1;
    %SS(F) = Struct;
