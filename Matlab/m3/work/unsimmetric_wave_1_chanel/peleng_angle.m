function arg = peleng_angle(W, BufFFT_w1, BufFFT_w2, EQ64, RN)
%function arg = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256)
% ������� ������� ���� ��� ������ ����� �������
%	������� ��������� ���������� ������� �������
%   ����:
%       - BufferFFTw1 � BufferFFTw2 - ������� EQ64�EQ256 ����������� �����
%       - energy - ������� EQ64�EQ256 �������� �������� � ������, ��
%         ��������� ���� ������ � 0 � ������ ���� ������
%       - EQ256 � EQ64 - ����������� ����� 256 � 64 ���������������
%   �����:
%       - arg - ����, � ������ �����

    %������������� ����������
    arg(1:EQ64,1:RN) = 0;  % �������� ������� � ������ 
    
    for i = 1:EQ64
        for j = 1:RN
            if ( W(i,j) > 0 ) % ��� �����, ��������� �����
                 % �������� ������������ �����
                x1 = imag(BufFFT_w1(i,j))/real(BufFFT_w1(i,j));
                x2 = imag(BufFFT_w2(i,j))/real(BufFFT_w2(i,j));
                arg(i,j) = atan(x1) - atan(x2);
                arg(i,j) = arg(i,j)*180/pi;
            else
                arg(i,j) = 0;
            end;            
        end;
    end;
end