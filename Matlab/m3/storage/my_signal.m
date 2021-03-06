clear all;
EQ256 = 16;   % ����� ������� ���������
EQ64 = 8;    % ����� ���������� �������

c = 3*10^8; %�������� �����
B = 50*10^6; %������ ��������� � ��
tau = 1300*10^-9; %�������� ������� �� ������������ ��������� � �
fm = 8*10^3; %������� ���������� ���� � ��
Tm = 1/fm; %������ ���������� ����
fb = B*tau/Tm; %����������� ������� �� ������������ ���������
Rd = c/(2*B); %���������� �� ���������
fd = 2000; %������� �������
R = 100; %��������� �� ����
tau1 = 2*R/c; %
fb1 = B*tau1/Tm; %
J = ceil(tau1/(5*10^-9)); %�������� � ������� ������
I = ceil(Tm/(5*10^-9)); %���������� �������� � ����� ������� ����

%������ �������
b = B/Tm; %����������� ���
FF = EQ64; %���������� ������������� ��������
mu=0; %���.��������
sigma=0.1; %���
RAND=(mu+sigma.*randn(1,1));
%1 �����
for i=0:1:I-1
    for j = 0:1:FF-1
    S1(i+1,j+1) = sin(2*pi*(5*10^-9)*(i+J)+pi*b*((i+J)*(5*10^-9))^2); %������ ������������ �������
    S2(i+1,j+1) = 1*(sin(2*pi*((i)*(5*10^-9))+pi*b*((i)*(5*10^-9))^2+2*pi*fd*j*Tm+(mu+sigma.*randn(1,1)))+RAND); %������ ��������� �������
                                                                                 %� ������������ �������� � ���������
    S3(i+1,j+1)=(S1(i+1,j+1)*S2(i+1,j+1)); %������ ������� � ������ ���������
    end
end
SS=resample(S3,2,25000/EQ256*2); %������ ������� ����� ���


%2 �����
f_1=pi*10/180;
fi2=f_1;
l=sqrt(-1);
for i=0:1:I-1
    for j = 0:1:FF-1
    %������ ������������ ������� �� ��
    SS2(i+1,j+1) = exp(l*fi2)*sin(2*pi*(i+1)*5*10^(-9)+pi*b*((i+1)*5*10^(-9))^(2)+2*pi*fd*(j+1)*Tm+RAND)+RAND; %������ ��������� �������
                                                                                 %� ������������ �������� � ���������
    SS3(i+1,j+1)=(S1(i+1,j+1)*SS2(i+1,j+1)); %������ ������� � ������ ���������
    end
end
SSS=resample(SS3,2,25000/EQ256*2);
