function W2 = processing(sL, sR, EQ64, EQ256, RN)
   
    % ���
    sL_hps(1:EQ64,1:256) = 0;
    sR_hps(1:EQ64,1:256) = 0;
    fdd = EQ256*8000;
    [b,a] = butter(1, 1e6/fdd, 'high'); 
    for i = 1:EQ64
        sL_hps(i,:) = filter(b,a,sL(i,:));
        sR_hps(i,:) = filter(b,a,sR(i,:));
    end;
    
    % ������� � ����� ��������
    BufIn1(1:EQ64,1:EQ256) = 0;
    BufIn2(1:EQ64,1:EQ256) = 0;
    w1=hamming(EQ256)';	% ���� ��������
    for i=1:EQ64
        BufIn1(i,:) = sL_hps(i,:).*w1;
        BufIn2(i,:) = sR_hps(i,:).*w1;
    end;

    % ��� �� �������� ������� (�� ������� �������)
    BufFFT_t1(1:EQ64,1:EQ256) = 0;
    BufFFT_t2(1:EQ64,1:EQ256) = 0;
    for i=1:EQ64
        BufFFT_t1(i,:) = fft(BufIn1(i,:));
        BufFFT_t2(i,:) = fft(BufIn2(i,:));
    end;

    % ������� ������������ �����
    % ����������� [256][64] � [50][64]
    BufFFT_t1(:,RN+1:EQ256) = [];
    BufFFT_t2(:,RN+1:EQ256) = [];

    % ������� � ����� ��������
    w2=hamming(EQ64);	% ���� ��������
    for i=1:RN
        BufIn1(:,i) = sL_hps(:,i).*w2;
        BufIn2(:,i) = sR_hps(:,i).*w2;
    end;

    % ��� �� ���������� ������� (�� ����������� ��������)
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);

    % ������ �������� � ������ ����� (����� ������� ��������������� ���� �����
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    % �������������� ������� ���������-�������� � ������������ ����
    W2(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W2(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
end
