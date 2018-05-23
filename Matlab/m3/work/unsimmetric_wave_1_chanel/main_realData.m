clear

EQ256 = 256;      % �����, ������������� 256
EQ128 = EQ256/2;  % �����, ������������� 256/2
EQ64 = 64;        % �����, ������������� 64
RN = 50;          % ���-�� ��������������� �������� �� ���������

Rd = 3;  %���������� �� ���������
Vd = 0.78125; %���������� �� ��������

%frames_full = load('C:\Users\Ignat\Desktop\DATAS\����\3\radar\nami3_2017_05_26__11_09_20.mat');
frames_full = load('C:\Users\Ignat\Desktop\DATAS\����\3\radar\nami3_2017_05_26__12_09_25.mat');
%frames_full = load('C:\Users\Ignat\Desktop\DATAS\����\3\radar\nami3_2017_05_26__13_30_12.mat');
frames = frames_full.Array_of_data();
% len=length(frames(1,:)); %������ ������
% start = 1;
 start = 860;
 len = start;

for F = start:len
    
    sL  = double(frames(F).data_1canal);  % 64*256 � ������ ������
    sR  = double(frames(F).data_2canal);  % 64*256 � ������� ������
  
    %W1 = processing_noFilter(sL, sR, EQ64, EQ256, RN);
    %W2 = processing(sL, sR, EQ64, EQ256,RN);
    [W3, BufFFT_w1, BufFFT_w2, A1, A2] = processing_withCorrection1(sL, sR, EQ64, EQ256, RN);
    %W = detector_const_threshold(W3, 6000, EQ64, RN);
    W = detector(W3, EQ64, RN);
    arg = peleng_angle(W, BufFFT_w1, BufFFT_w2, EQ64, RN);

    %������������ ����� ��� ���������� ��������
    ax = Rd:Rd:RN*Rd;    
    ay = -31*Vd:Vd:32*Vd;
    S = clustering(W, arg, Rd, Vd, EQ64, RN);

    Wp = Cluster_Draw(S, W);
    %image(ax, -ay, Wp);
    %colormap(winter);
    subplot(1,3,1); pcolor(ax,ay, W3);
    title('������� ���������-��������:');
    xlabel('���������, �');
    ylabel('������������� ��������, �/�');
    subplot(1,3,2); pcolor(ax,ay, W);
    title('������� ���������-��������:');
    xlabel('���������, �');
    ylabel('������������� ��������, �/�');
    subplot(1,3,3); image(ax,ay, Wp);
    title('������������� �����:');
    xlabel('���������, �');
    ylabel('������������� ��������, �/�');  
    
    pause(0.01);
end
