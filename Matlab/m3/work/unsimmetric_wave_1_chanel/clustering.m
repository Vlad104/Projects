function Struct = clustering(energy, arg, Rd, Vd, EQ64, EQ256)
%function [Struct, MAT] = clustering(energy, energy0, arg, EQ64, EQ256)
%	функция кластеризации
%   выделяет отдельные односвязные области
%   заполняет структуру данных для каждой области
%   вход:
%       - energy - матрица EQ64хEQ256 значений мощности в точках, со
%         значением выше порога и 0 в точках ниже порога
%       - energy0 - матрица EQ64хEQ256 значений мощности в каждой точке
%       - arg - угол, в каждой точке
%       - Rd и Vd - разрешение по дальности и скорости соответственно
%       - EQ256 и EQ64 - эквиваленты чисел 256 и 64 соответственно
%   выход:
%       - struct - структура:
%                           1 - номер области (цели), 
%                           2 - суммарная мощность области (цели), 
%                           3 - дальность до цели, 
%                           4 - относительная скорость цели, 
%                           5 - угол до цели, 
%                           6 - кол-во точек в области (нужно для отладки)  

    %инициализация переменных
    max_struct_size = 100; % максимальное колличество целей
    max_stack_pointer = 20; % максимальный размер области памяти для стека
    Struct(1:max_struct_size,1:8) = 0;  % создание структуры с нулями
    Mark(1:EQ64,1:EQ256) = 0;  % массив, с отметками о пройденных точках
    Stack(1:max_stack_pointer,1:2) = 0;  % массив (стэк), со значениями координат интересных точек
    struct_size = 1;  % номер цели в структуре
    MAT = energy; % нужно для визуализации кластеризации
    
    for ii = 1 : EQ64
        for jj = 1 : EQ256
            stack_pointer = 1;  % точка остановки в Stack
            i = ii;
            j = jj;
            flag = 0; % флаг = 0 - первый вход в while для текущих ii,jj
            while ( stack_pointer > 0 )
                if flag % если в стек были записаны координаты, то считываем последние из них
                    i = Stack(stack_pointer,1);
                    j = Stack(stack_pointer,2);
                end;
                flag = 1;          
                
                % точка должна не выходить за рамки массива, а также быть
                % не помеченной и ее мощность выше выше нуля
                if ( j <= EQ256 && i <= EQ64 && Mark(i,j) == 0 && energy(i,j) > 0 )

                    Struct(struct_size,1) = struct_size; % номер области
                    Struct(struct_size,2) = Struct(struct_size,2) + energy(i,j); % мощность области                
                    Struct(struct_size,3) = Struct(struct_size,3) + (j - 1)*energy(i,j); % дальность до цели                     
                    Struct(struct_size,4) = Struct(struct_size,4) + (i - EQ64/2)*energy(i,j); % относительная скорость цели           
                    Struct(struct_size,5) = Struct(struct_size,5) + arg(i,j)*energy(i,j); % угол до цели
                    Struct(struct_size,6) = Struct(struct_size,6) + 1; % кол-во точек в области (нужно для отладки)
                    Struct(struct_size,7) = i; % (нужно для отладки)
                    Struct(struct_size,8) = j; % (нужно для отладки)
                    

                    Mark(i,j) = 1; % помечаем точку пройденной, больше мы в неё не войдем
                    MAT(i,j) = struct_size; % нужно для визуализации кластеризации               
                    stack_pointer = stack_pointer - 1; % разрешаем запись в стеке поверх "отработанных" координат

                    %проверка точки справа, если она интересная, записываем
                    %её координаты в стэк
                    if ( j + 1 <= EQ256 && Mark(i, j+1) == 0 && energy(i, j+1) > 0) % && abs(arg(i,j) - arg(i,j+1)) < 2 )  
                        stack_pointer = stack_pointer + 1;
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j+1;
                    end;
                    
                    %проверка точки слева, если она интересная, записываем
                    %её координаты в стэк
                    if ( j - 1 >= 1 && Mark(i, j-1) == 0 && energy(i, j-1) > 0) % && abs(arg(i,j) - arg(i,j-1)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j-1;
                    end;

                    %проверка точки снизу, если она интересная, записываем
                    %её координаты в стэк
                    if ( i + 1 <= EQ64 && Mark(i+1, j) == 0 && energy(i+1, j) > 0) % && abs(arg(i,j) - arg(i+1,j)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i+1;
                        Stack(stack_pointer,2) = j;
                    end;

                    %проверка точки сверху, если она интересная, записываем
                    %её координаты в стэк
                    if ( i - 1 >= 1 && Mark(i-1, j) == 0 && energy(i-1, j) > 0) % && abs(arg(i,j) - arg(i-1,j)) < 2 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i-1;
                        Stack(stack_pointer,2) = j;
                    end;
                else
                    break;
                end;
            end;
            % если была зафиксирована хотя бы одна точка в области,
            % обзываем её целью
            if (struct_size < max_struct_size && Struct(struct_size,2) > 0)
                struct_size = struct_size + 1;
            end;
        end;
    end;
    
    %деление дальности, скорости и угла цели на суммарную мощность цели
    for i = 1:max_struct_size
        if (Struct(i,2) > 0)
            Struct(i,3) = Rd*Struct(i,3)/Struct(i,2); %*Rd
            Struct(i,4) = Vd*Struct(i,4)/Struct(i,2); %*Vd
            %Struct(i,5) = Struct(i,5)/Struct(i,2); %радианы
            Struct(i,5) = (180/pi)*Struct(i,5)/Struct(i,2); % градусы
        end;
    end;
end