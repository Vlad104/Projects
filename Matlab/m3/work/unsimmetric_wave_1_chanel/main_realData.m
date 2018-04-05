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

for F = 1:len
    
    sL  = double(frames(F).data_1canal); % 64*256 � ������ ������
    sR  = double(frames(F).data_2canal);  % 64*256 � ������� ������
  
    W1 = processing_noFilter(sL, sR, EQ256, EQ64, RN);
    W2 = processing_noFilter(sL, sR, EQ256, EQ64, RN); %��������
    %W3


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
