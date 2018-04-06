function W1 = processing_noFilter(BufIn1, BufIn2, EQ64, EQ256, RN)
    
    % ��� �� ���������� ������� (�� 256)
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

    % ��� �� ���������� ������� (�� 64)
    BufFFT_w1 = fft(BufFFT_t1);
    BufFFT_w2 = fft(BufFFT_t2);

    % ������ �������� � ������ ����� (����� ������� ��������������� ���� �����
    W0 = abs(BufFFT_w1) + abs(BufFFT_w2);
    
    % �������������� ������� ���������-�������� � ������������ ����
    W1(1:1:EQ64/2,:) = W0(EQ64/2:-1:1,:);
    W1(EQ64/2+1:1:64,:) = W0(EQ64:-1:EQ64/2+1,:);
end