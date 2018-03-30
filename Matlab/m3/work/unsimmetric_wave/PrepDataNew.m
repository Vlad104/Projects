function [ out1, out2 ] = PrepDataNew(sL1, sR1, a, b)
%	������� �������������� ������
%   ����:
%       - sL, sR - ������� ������� ������ �� ������ � ������� ������
%       - a, b - ������������ �������
%   �����:
%       - out1, out2 - ������� ���������-�������� �� �������

    N = 64; %���������� ����� � ������� ������
    M = 256; %���������� �������� � ������� ������
    K = 50; %���������� �������� �� ���������
    x=1:M;
    
    coeff1 = polyfit(x, sL1(1,:), 2); %������������ ��������� 2-�� �������
    coeff2 = polyfit(x, sR1(1,:), 2);
    
    for i=1:N %����������� ���
        sL1(i,:) = sL1(i,:) - polyval(coeff1, x);
        sR1(i,:) = sR1(i,:) - polyval(coeff2, x);
    end;
    
    sL=medfilt2(sL1,[1 5]);
    sR=medfilt2(sR1,[1 5]);
    
    [a1,b1]=butter(6,0.5);
    for i=1:N % ����������
        sL(i,:) = filter(a1,b1,sL(i,:));
        sR(i,:) = filter(a1,b1,sR(i,:));
    end
    
    for i=1:N % ����������
        s_out_L(i,:) = filter(a,b,sL(i,:));
        s_out_R(i,:) = filter(a,b,sR(i,:));
    end;  
   
    w=hamming(M); % ���� ��������
     for i=1:N %������� � �����
        for j=1:M
            BufferIn1(i,j)=s_out_L(i,j).*w(j);
            BufferIn2(i,j)=s_out_R(i,j).*w(j);
        end;
     end;

    % ��� �� "�������� �������"
    for i=1:N
        BufferFFTt1(i,:) = fft(BufferIn1(i,:));
        BufferFFTt2(i,:) = fft(BufferIn2(i,:));
    end;
   
    % �������� ������� ����� 1-�� �������������� �����
    for i=1:N
        s_out_L_64_50(i,:)=BufferFFTt1(i,1:K);
        s_out_R_64_50(i,:)=BufferFFTt2(i,1:K);
    end;  
    
    % �������� ���������������� �������
    BufferFFTt1 = s_out_L_64_50';
    BufferFFTt2 = s_out_R_64_50';
    
    w=hamming(N); % ���� ��������
     for i=1:K
        for j=1:N % ������� � �����
            BufferFFTt1(i,j)=BufferFFTt1(i,j).*w(j);
            BufferFFTt2(i,j)=BufferFFTt2(i,j).*w(j);
        end;
     end;

    % ��� �� "���������� �������"
    for i=1:K
        BufferFFTw1(i,:) = fft(BufferFFTt1(i,:));
        BufferFFTw2(i,:) = fft(BufferFFTt2(i,:));
    end;
    
    %�������� ����������������
    BufferFFTw1 = BufferFFTw1';
    BufferFFTw2 = BufferFFTw2';
    
    %���������� ������� � ������������ ����
    out1(1:N/2,:) = BufferFFTw1(N/2:-1:1,:);
    out1(N/2+1:N,:) = BufferFFTw1(N:-1:N/2+1,:);
    out2(1:N/2,:) = BufferFFTw2(N/2:-1:1,:);
    out2(N/2+1:N,:) = BufferFFTw2(N:-1:N/2+1,:);

end

