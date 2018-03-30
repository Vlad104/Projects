function arg = argument_amp(BufferFFTw1, BufferFFTw2, W, EQ64, EQ256)
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
    arg(1:EQ64,1:EQ256) = 0;  % �������� ������� � ������ 
    
    for i = 1:EQ64
        for j = 1:EQ256
            if ( W(i,j) > 0 ) % ��� �����, ��������� �����
                 % �������� ������������ �����
                x1 = imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j));
                x2 = imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j));
                arg(i,j) = atan(x1) - atan(x2);              
            else
                arg(i,j) = 0;
            end;            
        end;
    end;
end