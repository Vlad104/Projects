function energy = adaptive_filtering(energy0, k, EQ64, EQ256)
%	������� ��������� ���������� ������� �������
%   ����:
%       - energy0 - ������� EQ64�EQ256 �������� �������� � ������ �����
%       - k - ��������� ����������, ����������� ����������������� �������
%       - EQ256 � EQ64 - ����������� ����� 256 � 64 ���������������
%   �����:
%       - energy - ������� EQ64�EQ256 �������� �������� � ������, ��
%         ��������� ���� ������ � 0 � ������ ���� ������

    %������������� ����������
    energy(1:EQ64, 1:EQ256) = 0; % �������� ������� � ������
    S1 = 0; S2 = 0; % ���������� ��� ����������� ������� "����"
    
    for i = 1:EQ64
        for j = 1:EQ256
            if (6-j <= 0 && j <= (EQ256-5)) % ���� ������������� ������� �� �������� �� ����� �������
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;    
            if (j == 1)  % ��� ������� ����� �����
                S1 = energy0(i,EQ256-4) + energy0(i,EQ256-3) + energy0(i,EQ256-2);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;  
            if (j == 2)
                S1 = energy0(i,EQ256-3) + energy0(i,EQ256-2) + energy0(i,EQ256-1);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;
            if (j == 3)
                S1 = energy0(i,EQ256-2) + energy0(i,EQ256-1) + energy0(i,EQ256-0);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;            
            if (j == 4)
                S1 = energy0(i,EQ256-1) + energy0(i,EQ256-0) + energy0(i,1);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;            
            if (j == 5)
                S1 = energy0(i,EQ256-0) + energy0(i,1) + energy0(i,2);
                S1 = S1/3;
                S2 = energy0(i,j+3) + energy0(i,j+4) + energy0(i,j+5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;
            
            if (j == EQ256-0)  % ��� ������� ������ �����
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,3) + energy0(i,4) + energy0(i,5);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end; 
            if (j == EQ256-1)
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,2) + energy0(i,3) + energy0(i,4);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;
            if (j == EQ256-2)  
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,1) + energy0(i,2) + energy0(i,3);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;             
            if (j == EQ256-3)  
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,EQ256-0) + energy0(i,1) + energy0(i,2);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;            
            if (j == EQ256-4)  
                S1 = energy0(i,j-5) + energy0(i,j-4) + energy0(i,j-3);
                S1 = S1/3;
                S2 = energy0(i,EQ256-1) + energy0(i,EQ256-0) + energy0(i,1);
                S2 = S2/3;
                if ( ( (k*S1 < energy0(i,j)) && (k*S2 < energy0(i,j)) ) )
                    energy(i,j) = energy0(i,j);
                else
                    energy(i,j) = 0;
                end;
            end;             
        end;      
    end;
end