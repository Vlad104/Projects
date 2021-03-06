function [S, Rd] = signal_target1(EQ64, EQ256)
    c = 3*10^8; %�������� �����
    B = 150*10^6; %������ ��������� � ��
    fm = 1*10^3; %������� ���������� ���� � ��    
    tau = 1300*10^-9; %�������� ������� �� ������������ ��������� � �
    f0 = 24e9; %������� �������
    
    Tm = 1/fm; %������ ���������� ����
    fb = B*tau/Tm; %����������� ������� �� ������������ ���������
    Rd = c/(2*B); %���������� �� ���������
    Vd = (fm*c)/(2*EQ64*f0);  %���������� �� ��������
    kk = 5*10^-9;
    I = Tm/kk; %���������� �������� � ����� ������� ����
    
    % ���� 1
    fd1 = 2000; %������� �������    
    R1 = 100; %��������� �� ����
    tau1 = 2*R1/c; %
    fb1 = B*tau1/Tm; %
    J1 = tau1/kk; %�������� � ������� ������

    %������ ����������� ��������
    b = B/Tm; %����������� ���
    FF = EQ64; %���������� ������������� ��������
    fi=pi*15/180;
    l=sqrt(-1);    
    for i=0:1:I/2-1 %����������
        ZOND_1(i+1) = exp( fi*l)*sin(2*pi*kk*i*f0 + pi*b*(i*kk)^2); %������ ������������ ������� 
        ZOND_2(i+1) = exp(-fi*l)*sin(2*pi*(kk*i+Tm)*f0 + pi*b*(i*kk+Tm)^2); %������ ������������ �������
    end;    
    for i=I/2:1:I-1
        j = I-i;
        ZOND_1(i+1) = exp( fi*l)*sin(-2*pi*kk*j*f0 - pi*b*(j*kk)^2); %������ ������������ ������� 
        ZOND_2(i+1) = exp(-fi*l)*sin(-2*pi*(kk*j+Tm)*f0 - pi*b*(j*kk+Tm)^2); %������ ������������ �������
    end;            %����
    %������ �������� ��������
    mu=0; %���.��������
    sigma=0.1; %���
    RAND=(mu+sigma.*randn(1,1));
    fi1=pi*5/180;
    fi2=pi*25/180;
    % �������� ������ ����������� ������
    for i=0:1:I/2-1 %����������
        freq = 2*pi*kk*(i+J1)*f0 + pi*b*((i+J1)*kk)^2; %+ 2*pi*fd1*Tm;
        S11_RX(i+1) = exp( fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 1 �������
        S12_RX(i+1) = exp( fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 2 �������
        S13_RX(i+1) = exp(-fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 3 ������� 
        S14_RX(i+1) = exp(-fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 4 �������
    end;             %����
    for i=I/2:1:I-1
        j = I-i;
        freq = - 2*pi*kk*(j+J1)*f0 - pi*b*((j+J1)*kk)^2; %+ 2*pi*fd1*Tm;
        S11_RX(i+1) = exp( fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 1 �������
        S12_RX(i+1) = exp( fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 2 �������
        S13_RX(i+1) = exp(-fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 3 ������� 
        S14_RX(i+1) = exp(-fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 4 �������
    end;
    % �������� ������ ����������� ������
    for i=0:1:I/2-1 %����������
        freq = 2*pi*(kk*(i+J1)+Tm)*f0 + pi*b*((i+J1)*kk+Tm)^2; %+ 2*pi*fd1*Tm;
        S21_RX(i+1) = exp( fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 1 �������
        S22_RX(i+1) = exp( fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 2 �������
        S23_RX(i+1) = exp(-fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 3 ������� 
        S24_RX(i+1) = exp(-fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 4 �������
    end;             %����
    for i=I/2:1:I-1
        j = I-i;
        freq = - 2*pi*(kk*(j+J1)+Tm)*f0 - pi*b*((j+J1)*kk+Tm)^2; %+ 2*pi*fd1*Tm;
        S21_RX(i+1) = exp( fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 1 �������
        S22_RX(i+1) = exp( fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 2 �������
        S23_RX(i+1) = exp(-fi1*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 3 ������� 
        S24_RX(i+1) = exp(-fi2*l)*sin(freq + (mu+sigma.*randn(1,1))) + RAND; %������ ������� �� 4 �������
    end;
    
    %������ �� ������ ���������
    for i=0:1:I-1
        S_SM(i+1,1) = ZOND_1(i+1)*S11_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,2) = ZOND_1(i+1)*S12_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,3) = ZOND_1(i+1)*S13_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,4) = ZOND_1(i+1)*S14_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,5) = ZOND_2(i+1)*S21_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,6) = ZOND_2(i+1)*S22_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,7) = ZOND_2(i+1)*S23_RX(i+1); %������ ������� � ������ ���������
        S_SM(i+1,8) = ZOND_2(i+1)*S24_RX(i+1); %������ ������� � ������ ���������
    end;

    rsm_p = 2; % ����� ��� �������������� ������� � EQ256 ��������
    rsm_q = double(int16(rsm_p*size(S_SM,1)/EQ256));
    for i = 1:1:8
        S(:,i) = resample(S_SM(:,i), rsm_p, rsm_q);
    end;
    while (size(S,1) > EQ256) % ���� �������� ��� ������ 256 �����
    	S(size(S,1),:) = []; %������ ������� ����� ���
    end;  
end