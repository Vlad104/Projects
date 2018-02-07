function [S1, S2, Rd, Vd] = signal_target1(EQ64, EQ256)
    %������������� ������
    ZOND(1:25000,1:64) = 0;     %����������� ������
    S1_RX(1:25000,1:64) = 0;    %������, �������� ������ ��������
    S2_RX(1:25000,1:64) = 0;    %������, �������� ����� ��������
    S1_SM(1:25000,1:64) = 0;    %������ �� ������ ��������� 1
    S2_SM(1:25000,1:64) = 0;    %������ �� ������ ��������� 2
    S1(1:256,1:64) = 0;         %������ 1 ����� ���
    S2(1:256,1:64) = 0;         %������ 2 ����� ���

    c = 3*10^8; %�������� �����
    B = 50*10^6; %������ ��������� � ��
    fm = 8*10^3; %������� ���������� ���� � ��    
    tau0 = 1300*10^-9; %�������� ������� �� ������������ ��������� � �
    f0 = 24e9; %������� �������
    
    Tm = 1/fm; %������ ���������� ����
    fb0 = B*tau0/Tm; %����������� ������� �� ������������ ���������
    Rd = c/(2*B); %���������� �� ���������
    Vd = (fm*c)/(2*EQ64*f0);  %���������� �� ��������
    kk = 5*10^-9; %����������� �����������
    I = Tm/kk; %���������� �������� � ����� ������� ����
    
    %������ �������
    b = B/Tm; %����������� ���
    FF = EQ64; %���������� ������������� ��������
    mu=0; %���.��������
    sigma=0.1; %���
    RAND=(mu+sigma.*randn(1,1));
    
    % ��� ������� ���������� ����� ����� ����� �������� ���������� N.
    % (������: N = 3; - 3 ����).
    % ��� ������ ���� ��������� ��������� ���������� ���� �� ����� ����1,
    % ������� ������� � ������� ������� ����
    
    N = 1; %���-�� �����
    %������������� �������� ������ ��� ��������� ��������
    fd(1:N) = 0; 
    R(1:N) = 0; 
    tau(1:N) = 0; 
    fb(1:N) = 0; 
    J(1:N) = 0;
    phi_grad(1:N) = 0;
    phi(1:N) = 0;
    
    % ���� 1. ��������� ������
    V(1) = -2*Vd; % �������� ����, �/�
    R(1) = 100; %��������� �� ����, �
    phi_grad(1) = 45; %���� ������� � ��������
    % ���� 1. ��������� �����
    
    % ������ �������������� ���������� ��� ������ ����
    for z = 1:1:N
        phi(z) = phi_grad(z)*pi/180; %���� ������� � ��������
        fd(z) = V(z)*f0*2/c; % ������� �������  
        tau(z) = 2*R(z)/c; % ����� �������� �� ����
        J(z) = tau(z)/kk; %�������� � ������� ������
        fb(z) = B*tau(z)/Tm; %����������� ������� �� ������������ ���������
    end;
    
    %����������� ������
    for i=0:1:I-1
        for j = 0:1:FF-1
            ZOND(i+1,j+1) = sin(2*pi*kk*i*f0 + pi*b*(i*kk)^2); %������ ������������ �������        
        end;
    end;  
    
    frx1 =  2*pi/180;
    frx2 = -2*pi/180;
    l = sqrt(-1);
    %�������, �������� ��������
    for i=0:1:I-1
        for j = 0:1:FF-1
            for z = 1:1:N
                freq = 2*pi*(i+J(z))*kk*f0 + pi*b*((i+J(z))*kk)^2 + 2*pi*fd(z)*j*Tm;
                S1_RX(i+1,j+1) = S1_RX(i+1,j+1) + exp(frx1*l)*exp(phi(z)*l)*sin(freq + (mu+sigma.*randn(1,1))) + (mu+sigma.*randn(1,1));
                S2_RX(i+1,j+1) = S1_RX(i+1,j+1) + exp(frx2*l)*exp(phi(z)*l)*sin(freq + (mu+sigma.*randn(1,1))) + (mu+sigma.*randn(1,1));
            end;
        end;
    end;
    
    %������� �� ������ ���������
    for i=0:1:I-1
        for j = 0:1:FF-1    
            S1_SM(i+1,j+1)=(ZOND(i+1,j+1)*S1_RX(i+1,j+1)); 
            S2_SM(i+1,j+1)=(ZOND(i+1,j+1)*S2_RX(i+1,j+1));
        end;
    end; 
       
    
    rsm_p = 2; % ����� ��� �������������� ������� � EQ256 ��������
    rsm_q = double(int16(rsm_p*size(S1_SM,1)/EQ256));
    S1=resample(S1_SM,rsm_p,rsm_q); % �������� (�������������) �������
    S2=resample(S2_SM,rsm_p,rsm_q); % �������� (�������������) ������� 
    while (size(S1,1) > EQ256) % ���� �������� ��� ������ 256 �����
        S1(size(S1,1),:) = []; %������ ������� ����� ���
    end;
    while (size(S2,1) > EQ256) % ���� �������� ��� ������ 256 �����
        S2(size(S2,1),:) = []; %������ ������� ����� ���
    end;
end