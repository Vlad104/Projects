clear

EQ256 = 256;      % �����, ������������� 256
EQ128 = EQ256/2;  % �����, ������������� 256/2
EQ64 = 64;        % �����, ������������� 64
RN = 50;          % ���-�� ��������������� �������� �� ���������

Rd = 3;  %���������� �� ���������
Vd = 0.78125; %���������� �� ��������

frames_full = load('C:\Users\Ignat\Desktop\DATAS\����\3\radar\nami3_2017_05_26__10_46_32.mat'); 
frames = frames_full.Array_of_data();
len=length(frames(1,:)); %������ ������
% len = 1;

for F = 1:len
    
    sL  = double(frames(F).data_1canal); % 64*256 � ������ ������
    sR  = double(frames(F).data_2canal);  % 64*256 � ������� ������
    sL = sL';
    sR = sR';
    
    % ������ ���� ������� �������� � ���� �������
    % [sL, sR, Rd, Vd] = signal_target1(EQ64, EQ256);
    
    [W1, BufFFT_w1, BufFFT_w2] = processing(sL, sR, EQ256, EQ64, RN);
    W2 = correction(sL, sR, EQ256, EQ64, RN);
    W3 = no_filter(sL, sR, EQ256, EQ64, RN);


    k = 6; % ����������� ������
    n_look = 10; % ����������� ������������ ����� 
    n_miss = 2; % ����������� ������������ �����

    % ��������� ����������
    W = threshold_filter(W1, k, EQ64, RN, n_look, n_miss);

    % ������ ����
    %arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256/2);
    arg = argument_amp(BufFFT_w1, BufFFT_w2, W, EQ64, RN);

    % ������������� � ���������� ���������
    % ������� �������� � 32 ������ energy -> 64 ������ ��������������
    Struct = clustering(W, W1, arg, Rd, Vd, EQ64, RN);

    %������������ ����� ��� ���������� ��������
    ax = Rd:Rd:RN*Rd;    
    ay = -31*Vd:Vd:32*Vd;

    colormap(jet);
    subplot(1,3,1);pcolor(ax,ay, W1);
    subplot(1,3,2);pcolor(ax,ay, W2);
    subplot(1,3,3);pcolor(ax,ay, W3);
    F
    %title(['����� �����: ', num2str(F)]);
    %xlabel('���������, �');
    %ylabel('������������� ��������, �/�');
    %zlabel('��������');   
    
    pause(0.01);
end
