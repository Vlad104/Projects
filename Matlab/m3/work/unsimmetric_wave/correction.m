function W2 = correction(sL1, sR1, EQ256, EQ64, RN)
%	������� �������������� ������
%   ����:
%       - sL, sR - ������� ������� ������ �� ������ � ������� ������
%       - a, b - ������������ �������
%   �����:
%       - out1, out2 - ������� ���������-�������� �� �������

    sL(1:256,1:64) = 0;
    sR(1:256,1:64) = 0;

    %�������� ������������� �������
%     a = [0.92703707226149745000, -0.92703707226149745000];
%     b = [1.00000000000000000000, -0.85408068546991278000];
    
    [a,b] = butter(1, 1e6/3e6, 'high');
    
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
    sL_f = filter(a,b,sL);
    sR_f = filter(a,b,sR);

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

    % ��� �� �������� �������
    BufFFT_t1 = fft(BufIn1);
    BufFFT_t2 = fft(BufIn2);

    %������� ������������ �����
    %����������� [256][64] � [128][64]
    BufFFT_t1(RN+1:EQ256,:) = [];
    BufFFT_t2(RN+1:EQ256,:) = [];

    % �������� ���������������� �������
    BufFFT_t1 = BufFFT_t1';
    BufFFT_t2 = BufFFT_t2';

    w2=hamming(EQ64); %���� ��������
    %������� � ����� ��������
    for i=1:EQ64
        for j=1:RN
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
      
end