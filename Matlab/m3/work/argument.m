function angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256)
% ������� ������� ���� ��� ������ ����� �������
%	������� ��������� ���������� ������� �������
%   ����:
%       - BufferFFTw1 � BufferFFTw2 - ������� EQ64�EQ256 ����������� �����
%       - energy - ������� EQ64�EQ256 �������� �������� � ������, ��
%         ��������� ���� ������ � 0 � ������ ���� ������
%       - EQ256 � EQ64 - ����������� ����� 256 � 64 ���������������
%   �����:
%       - angle - ����, � ������ �����

    %������������� ����������
    angle(1:EQ64,1:EQ256) = 0;  % �������� ������� � ������ 
    
    for i = 1:EQ64
        for j = 1:EQ256
            if ( energy(i,j) > 0 ) % ��� �����, ��������� �����
                 % �������� ������������ �����
                angle(i,j) = atan( imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j)) ) - atan( imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j)) );
            else
                % ����� ������ else, �� �� ����� ��� ���������� �� ��
                angle(i,j) = 0;
            end;            
        end;
    end;
end