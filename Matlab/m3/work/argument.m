function angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256)
% функция расчета угла для каждой точки матрицы
%	функция пороговой фильтрации входной матрицы
%   вход:
%       - BufferFFTw1 и BufferFFTw2 - матрицы EQ64хEQ256 комплексных чисел
%       - energy - матрица EQ64хEQ256 значений мощности в точках, со
%         значением выше порога и 0 в точках ниже порога
%       - EQ256 и EQ64 - эквиваленты чисел 256 и 64 соответственног
%   выход:
%       - angle - угол, в каждой точке

    %инициализация переменных
    angle(1:EQ64,1:EQ256) = 0;  % создание массива с нулями 
    
    for i = 1:EQ64
        for j = 1:EQ256
            if ( energy(i,j) > 0 ) % для точек, прошедших порог
                 % аргумент комплексного числа
                angle(i,j) = atan( imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j)) ) - atan( imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j)) );
            else
                % можно убрать else, но он нужен при реализации на Си
                angle(i,j) = 0;
            end;            
        end;
    end;
end