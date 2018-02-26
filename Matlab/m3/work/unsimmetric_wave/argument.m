function arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256)
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
            if ( energy(i,j) > 0 ) % ��� �����, ��������� �����
                 % �������� ������������ �����
                x1 = imag(BufferIn1(j,i))/real(BufferIn1(j,i));
                x2 = imag(BufferIn2(j,i))/real(BufferIn2(j,i));
                arg(i,j) = ( atan(x1) + atan(x2) )/2;
%                 x1 = imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j));
%                 x2 = imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j));
%                 arg(i,j) = atan( (x1 - x2)/(x1 + x2) ) ;                
            else
                arg(i,j) = 0;
            end;            
        end;
    end;
end