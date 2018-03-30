function W3 = no_filter(BufIn1, BufIn2, EQ256, EQ64)
%	������� �������������� ������
%   ����:
%       - sL, sR - ������� ������� ������ �� ������ � ������� ������
%       - a, b - ������������ �������
%   �����:
%       - out1, out2 - ������� ���������-�������� �� �������

    
    BufIn1(1:256,1:64) = 0;
    BufIn2(1:256,1:64) = 0;    
    BufFFT_t1(1:256,1:64) = 0;
    BufFFT_t2(1:256,1:64) = 0;    
    BufFFT_w1(1:64,1:128) = 0;
    BufFFT_w2(1:64,1:128) = 0;
   
    % ��� �� �������� �������
    %%BufFFT_t1 = fft(BufIn1);
    %%BufFFT_t2 = fft(BufIn2);
    
    for i=1:EQ64
        BufFFT_t1(:,i) = fft(BufIn1(:,i));
        BufFFT_t2(:,i) = fft(BufIn2(:,i));
    end;

    %������� ������������ �����
    %����������� [256][64] � [128][64]
    BufFFT_t1(EQ256/2+1:EQ256,:) = [];
    BufFFT_t2(EQ256/2+1:EQ256,:) = [];

    % �������� ���������������� �������
    BufFFT_t1 = BufFFT_t1';
    BufFFT_t2 = BufFFT_t2';

    % ��� �� ���������� �������
    %BufFFT_w1 = fft(BufFFT_t1);
    %BufFFT_w2 = fft(BufFFT_t2);
    
    for i=1:EQ64
        BufFFT_w1(i,:) = fft(BufFFT_t1(i,:));
        BufFFT_w2(i,:) = fft(BufFFT_t2(i,:));
    end;

    % ������ �������� � ������ ����� (����� ������� ��������������� ���� �����)
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    % �������������� ������� ���������-�������� � ������������ ����

    W3(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W3(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
    
%     Rd = 3;  %���������� �� ���������
%     Vd = 0.78125; %���������� �� ��������
%     ax = Rd:Rd:128*Rd;    
%     ay = -31*Vd:Vd:32*Vd;
%     colormap(jet);
%     pcolor(ax,ay, W3);
end