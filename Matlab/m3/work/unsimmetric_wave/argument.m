function arg = argument(BufferIn1, BufferIn2, energy, EQ64, EQ256)
%function arg = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256)
% функция расчета угла для каждой точки матрицы
%	функция пороговой фильтрации входной матрицы
%   вход:
%       - BufferFFTw1 и BufferFFTw2 - матрицы EQ64хEQ256 комплексных чисел
%       - energy - матрица EQ64хEQ256 значений мощности в точках, со
%         значением выше порога и 0 в точках ниже порога
%       - EQ256 и EQ64 - эквиваленты чисел 256 и 64 соответственног
%   выход:
%       - arg - угол, в каждой точке

    %инициализация переменных
    arg(1:EQ64,1:EQ256) = 0;  % создание массива с нулями 
    
    for i = 1:EQ64
        for j = 1:EQ256
            if ( energy(i,j) > 0 ) % для точек, прошедших порог
                 % аргумент комплексного числа
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