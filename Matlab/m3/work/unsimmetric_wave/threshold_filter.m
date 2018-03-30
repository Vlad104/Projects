function energy = threshold_filter(energy0, k, EQ64, EQ256, n_look, n_miss)
%	������� ��������� ���������� ������� �������
%   ����:
%       - energy0 - ������� EQ64�EQ256 �������� �������� � ������ �����
%       - k - ��������� ����������, ����������� ����������������� �������
%       - EQ256 � EQ64 - ����������� ����� 256 � 64 ��������������
%       - n_look - ����� ����� ��� ������� �������� ��������
%       - n_miss - ����� ����������� �����
%   �����:
%       - energy - ������� EQ64�EQ256 �������� �������� � ������, ��
%         ��������� ���� ������ � 0 � ������ ���� ������

    %������������� ���������� %%
    energy(1:EQ64, 1:EQ256) = 0; % �������� ������� � ������
    n = n_look + n_miss;
    temp(1:EQ64+2*n) = 0;
    
    for i = 1:EQ64
        temp(1:n) = 0; % = energy0(n+1:);
        temp(n+1:EQ256+n) = energy0(i,1:EQ256);
        temp(EQ256+n+1:EQ256+2*n) = 0; % = energy0(i,1:n);
        for j = n+1:EQ256+n
            S1 = 0;
            S2 = 0;
            for z = 1:n_look
                S1 = S1 + temp(j+n_miss+z); 
                S2 = S2 + temp(j-n_miss-z); 
            end;
            S1 = S1/n_look;
            S2 = S2/n_look;
            if ( j >= n+1 && j <= EQ256+n && temp(j) > k*S1 && temp(j) > k*S2 )
                energy(i,j-n) = temp(j);
            else
                energy(i,j-n) = 0;
            end;                
        end;      
    end;
end