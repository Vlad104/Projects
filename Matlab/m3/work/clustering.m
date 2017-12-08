function Struct = clustering(energy, energy0, angle, EQ64, EQ256)
%function [Struct, MAT] = clustering(energy, energy0, angle, EQ64, EQ256)
%	������� �������������
%   �������� ��������� ����������� �������
%   ��������� ��������� ������ ��� ������ �������
%   ����:
%       - energy - ������� EQ64�EQ256 �������� �������� � ������, ��
%         ��������� ���� ������ � 0 � ������ ���� ������
%       - energy0 - ������� EQ64�EQ256 �������� �������� � ������ �����
%       - angle - ����, � ������ �����
%       - EQ256 � EQ64 - ����������� ����� 256 � 64 ���������������
%   �����:
%       - struct - ���������:
%                           1 - ����� ������� (����), 
%                           2 - ��������� �������� ������� (����), 
%                           3 - ��������� �� ����, 
%                           4 - ������������� �������� ����, 
%                           5 - ���� �� ����, 
%                           6 - ���-�� ����� � ������� (����� ��� �������)  

    %������������� ����������
    max_struct_size = 2000; % ������������ ����������� �����
    max_stack_pointer = 100; % ������������ ������ ������� ������ ��� �����
    Struct(1:max_struct_size,1:6) = 0;  % �������� ��������� � ������
    Mark(1:EQ64,1:EQ256) = 0;  % ������, � ��������� � ���������� ������
    Stack(1:max_stack_pointer,1:2) = 0;  % ������ (����), �� ���������� ��������� ���������� �����
    struct_size = 1;  % ����� ���� � ���������
    MAT = energy; % ����� ��� ������������ �������������
    
    for ii = 1 : EQ64
        for jj = 1 : EQ256
            stack_pointer = 1;  % ����� ��������� � Stack
            i = ii;
            j = jj;
            flag = 0; % ���� = 0 - ������ ���� � while ��� ������� ii,jj
            while ( stack_pointer > 0 )
                if flag % ���� � ���� ���� �������� ����������, �� ��������� ��������� �� ���
                    i = Stack(stack_pointer,1);
                    j = Stack(stack_pointer,2);
                end;
                flag = 1;          
                
                % ����� ������ �� �������� �� ����� �������, � ����� ����
                % �� ���������� � �� �������� ���� ���� ����
                if ( j <= EQ256 && i <= EQ64 && Mark(i,j) == 0 && energy(i,j) > 0 )

                    Struct(struct_size,1) = struct_size; % ����� �������
                    Struct(struct_size,2) = Struct(struct_size,2) + energy0(i,j); % �������� �������                
                    Struct(struct_size,3) = Struct(struct_size,3) + j*energy0(i,j); % ��������� �� ���� 
                    Struct(struct_size,4) = Struct(struct_size,4) + (i - EQ64/2)*energy0(i,j); % ������������� �������� ����                
                    Struct(struct_size,5) = Struct(struct_size,5) + angle(i,j)*energy0(i,j); % ���� �� ����
                    Struct(struct_size,6) = Struct(struct_size,6) + 1; % ���-�� ����� � ������� (����� ��� �������)

                    Mark(i,j) = 1; % �������� ����� ����������, ������ �� � �� �� ������
                    MAT(i,j) = struct_size; % ����� ��� ������������ �������������               
                    stack_pointer = stack_pointer - 1; % ��������� ������ � ����� ������ "������������" ���������

                    %�������� ����� ������, ���� ��� ����������, ����������
                    %� ���������� � ����
                    if ( j + 1 <= EQ256 && Mark(i, j+1) == 0 && energy(i, j+1) > 0 && abs(angle(i,j) - angle(i,j+1)) < 2 )  
                        stack_pointer = stack_pointer + 1;
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j+1;
                    end;
                    
                    %�������� ����� �����, ���� ��� ����������, ����������
                    %� ���������� � ����
                    if ( j - 1 >= 1 && Mark(i, j-1) == 0 && energy(i, j-1) > 0 && abs(angle(i,j) - angle(i,j-1)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j-1;
                    end;

                    %�������� ����� �����, ���� ��� ����������, ����������
                    %� ���������� � ����
                    if ( i + 1 <= EQ64 && Mark(i+1, j) == 0 && energy(i+1, j) > 0 && abs(angle(i,j) - angle(i+1,j)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i+1;
                        Stack(stack_pointer,2) = j;
                    end;

                    %�������� ����� ������, ���� ��� ����������, ����������
                    %� ���������� � ����
                    if ( i - 1 >= 1 && Mark(i-1, j) == 0 && energy(i-1, j) > 0 && abs(angle(i,j) - angle(i-1,j)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i-1;
                        Stack(stack_pointer,2) = j;
                    end;
                else
                    break;
                end;
            end;
            % ���� ���� ������������� ���� �� ���� ����� � �������,
            % �������� � �����
            if (struct_size < max_struct_size && Struct(struct_size,2) > 0)
                struct_size = struct_size + 1;
            end;
        end;
    end;
    
    %������� ���������, �������� � ���� ���� �� ��������� �������� ����
    for i = 1:max_struct_size
        if (Struct(struct_size,2) > 0)
            Struct(i,3) = Struct(i,3)/Struct(i,2);
            Struct(i,4) = Struct(i,4)/Struct(i,2);
            Struct(i,5) = Struct(i,5)/Struct(i,2);
        end;
    end;
end