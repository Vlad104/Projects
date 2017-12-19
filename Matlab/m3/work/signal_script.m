    clear
    EQ64 = 64; 
    EQ256 = 256; 
    c = 3*10^8; %�������� �����
    B = 50*10^6; %������ ��������� � ��
    fm = 8*10^3; %������� ���������� ���� � ��    
    tau = 1300*10^-9; %�������� ������� �� ������������ ��������� � �
    f0 = 24e9; %������� �������
    
    Tm = 1/fm; %������ ���������� ����
    fb = B*tau/Tm; %����������� ������� �� ������������ ���������
    Rd = c/(2*B); %���������� �� ���������
    tk = 5*10^-9; %��������� �����������
    I = Tm/tk; %���������� �������� � ����� ������� ����
      
     % ���� 1
    fd1 = -2000; %������� �������    
    R1 = 320; %��������� �� ����
    tau1 = 2*R1/c; %
    fb1 = B*tau1/Tm; %
    J1 = tau1/tk; %�������� � ������� ������

    % ���� 2
    fd2 = 1000; %������� �������
    R2 = 200;
    tau2 = 2*R2/c;
    fb2 = B*tau2/Tm;
    J2 = tau2/tk;
    
    % ���� 3
    fd3 = -3000; %������� �������
    R3 = 50;
    tau3 = 2*R3/c;
    fb3 = B*tau3/Tm;
    J3 = tau3/tk;
    
    % ���� 4
    fd4 = 3000; %������� �������
    R4 = 150;
    tau4 = 2*R4/c;
    fb4 = B*tau4/Tm;
    J4 = tau4/tk;

    %������ �������
    b = B/Tm; %����������� ���
    FF = EQ64; %���������� ������������� ��������
    mu=0; %���.��������
    sigma=0.1; %���
    RAND=(mu+sigma.*randn(1,1));
    %1 �����
    %aa = 0.0001; 
    aa = 0;
    l=sqrt(-1);
    for i=0:1:I-1
        for j = 0:1:FF-1
            ZOND(i+1,j+1) = sin(2*pi*tk*i*f0 + pi*b*(i*tk)^2); %������ ������������ �������        
            
            S1_RX(i+1,j+1) = exp(l*aa)*sin(2*pi*(i+J1)*tk*f0 + pi*b*((i+J1)*tk)^2 + 2*pi*fd1*j*Tm + (mu+sigma.*randn(1,1))) + RAND; %������ ��������� ������� ���� 1
            S1_RX(i+1,j+1) = S1_RX(i+1,j+1) + exp(l*aa)*sin(2*pi*(i+J2)*tk*f0 + pi*b*((i+J2)*tk)^2 + 2*pi*fd2*j*Tm + (mu+sigma.*randn(1,1))) + RAND; %������ ��������� ������� ���� 2  
            S1_RX(i+1,j+1) = S1_RX(i+1,j+1) + exp(l*aa)*sin(2*pi*(i+J3)*tk*f0 + pi*b*((i+J3)*tk)^2 + 2*pi*fd3*j*Tm + (mu+sigma.*randn(1,1))) + RAND; %������ ��������� ������� ���� 3  
            S1_RX(i+1,j+1) = S1_RX(i+1,j+1) + exp(l*aa)*sin(2*pi*(i+J4)*tk*f0 + pi*b*((i+J4)*tk)^2 + 2*pi*fd4*j*Tm + (mu+sigma.*randn(1,1))) + RAND; %������ ��������� ������� ���� 4  
                        
            S1_SM(i+1,j+1)=(ZOND(i+1,j+1)*S1_RX(i+1,j+1)); %������ ������� � ������ ���������
        end;
    end;
    
    rsm_p = 2; % ����� ��� �������������� ������� � EQ256 ��������
    rsm_q = double(int16(rsm_p*size(S1_SM,1)/EQ256));
    S1=resample(S1_SM,rsm_p,rsm_q); % �������� (�������������) �������
    %S1(:,:)=0;    
    while (size(S1,1) > EQ256) % ���� �������� ��� ������ 256 �����
        S1(size(S1,1),:) = []; %������ ������� ����� ���
    end;

    %2 �����
    f_1=pi*10/180;
    fi2=f_1;
    l=sqrt(-1);
    for i=0:1:I-1
        for j = 0:1:FF-1
        %������ ������������ ������� �� ��
        S2_RX(i+1,j+1) = exp(l*fi2)*sin(2*pi*(i+J1)*tk*f0 + pi*b*((i+J1)*tk)^2 + 2*pi*fd1*(j)*Tm+RAND)+RAND; %������ ��������� ������� ���� 1
        S2_RX(i+1,j+1) = S2_RX(i+1,j+1) + exp(l*fi2)*sin(2*pi*(i+J2)*tk*f0 + pi*b*((i+J2)*tk)^2 + 2*pi*fd2*(j)*Tm+RAND)+RAND; %������ ��������� ������� ���� 2 
        S2_RX(i+1,j+1) = S2_RX(i+1,j+1) + exp(l*fi2)*sin(2*pi*(i+J3)*tk*f0 + pi*b*((i+J3)*tk)^2 + 2*pi*fd3*(j)*Tm+RAND)+RAND; %������ ��������� ������� ���� 3
        S2_RX(i+1,j+1) = S2_RX(i+1,j+1) + exp(l*fi2)*sin(2*pi*(i+J4)*tk*f0 + pi*b*((i+J4)*tk)^2 + 2*pi*fd4*(j)*Tm+RAND)+RAND; %������ ��������� ������� ���� 4
        
        S2_SM(i+1,j+1)=(ZOND(i+1,j+1)*S2_RX(i+1,j+1)); %������ ������� � ������ ���������
        end;
    end;
    rsm_p = 2; % ����� ��� �������������� ������� � EQ256 ��������
    rsm_q = double(int16(rsm_p*size(S2_SM,1)/EQ256));
    S2=resample(S2_SM,rsm_p,rsm_q); % �������� (�������������) �������
    %S2(:,:)=0;
    while (size(S2,1) > EQ256) % ���� �������� ��� ������ 256 �����
        S2(size(S2,1),:) = []; %������ ������� ����� ���
    end;