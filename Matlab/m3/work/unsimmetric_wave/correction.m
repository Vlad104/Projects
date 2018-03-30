function W2 = correction(sL1, sR1, EQ256, EQ64)
%	������� �������������� ������
%   ����:
%       - sL, sR - ������� ������� ������ �� ������ � ������� ������
%       - a, b - ������������ �������
%   �����:
%       - out1, out2 - ������� ���������-�������� �� �������

    sL_p(1:256,1:64) = 0;
    sR_p(1:256,1:64) = 0;

    %�������� ������������� �������
    a = [0.92703707226149745000, -0.92703707226149745000];
    b = [1.00000000000000000000, -0.85408068546991278000];
    
    x = 1:EQ256;
    coeff1 = polyfit(x, sL1(:,1)', 2); %������������ ��������� 2-�� �������
    coeff2 = polyfit(x, sR1(:,1)', 2);

    for i=1:EQ64 %����������� ���
        sL1(:,i) = sL1(:,i) - polyval(coeff1, x)';
        sR1(:,i) = sR1(:,i) - polyval(coeff2, x)';
    end;
    
    sL=medfilt2(abs(sL1),[1 5]);
    sR=medfilt2(abs(sR1),[1 5]);
    
    [a1,b1]=butter(6,0.5);
    
    for i=1:EQ64 % ����������
        sL(:,i) = filter(a1,b1,sL(:,i));
        sR(:,i) = filter(a1,b1,sR(:,i));
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    sL_f = filter(a,b,sL_p);
    sR_f = filter(a,b,sR_p);

    w1=hamming(EQ256); %���� ��������
    BufIn1(1:256,1:64) = 0;
    BufIn2(1:256,1:64) = 0;
    %������� � ����� ��������
    for i=1:EQ256
        for j=1:EQ64
            BufIn1(i,j) = sL_f(i,j)*w1(i);
            BufIn2(i,j) = sR_f(i,j)*w1(i);
        end;
    end;

    % for i=1:EQ64
    %     BufferIn1(:,i) = conv(sL_f(:,i),w1);
    %     BufferIn2(:,i) = conv(sR_f(:,i),w1);
    % end;

    % ��� �� �������� �������
    BufFFT_t1 = fft(BufIn1);
    BufFFT_t2 = fft(BufIn2);

    %������� ������������ �����
    %����������� [256][64] � [128][64]
    BufFFT_t1(EQ256/2+1:EQ256,:) = [];
    BufFFT_t2(EQ256/2+1:EQ256,:) = [];

    % �������� ���������������� �������
    BufFFT_t1 = BufFFT_t1';
    BufFFT_t2 = BufFFT_t2';

    w2=hamming(EQ64); %���� ��������
    %������� � ����� ��������
    for i=1:EQ64
        for j=1:EQ256/2
            BufFFT_t1(i,j) = BufFFT_t1(i,j).*w2(i);
            BufFFT_t2(i,j) = BufFFT_t2(i,j).*w2(i);
        end;
    end;

    % ��� �� ���������� �������
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);

    % ������ �������� � ������ ����� (����� ������� ��������������� ���� �����)
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    % �������������� ������� ���������-�������� � ������������ ����
    %energy1 = energy0;
    W2(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W2(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
      
%     Rd = 3;  %���������� �� ���������
%     Vd = 0.78125; %���������� �� ��������  
%     ax = Rd:Rd:128*Rd;    
%     ay = -31*Vd:Vd:32*Vd;
%     colormap(jet);
%     pcolor(ax,ay, abs(BufFFT_w1));
end