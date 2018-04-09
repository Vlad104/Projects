function arg = peleng_angle(W, BufFFT_w1, BufFFT_w2, EQ64, RN)
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
    arg(1:EQ64,1:RN) = 0;  % создание массива с нулями 
    
    for i = 1:EQ64
        for j = 1:RN
            if ( W(i,j) > 0 ) % для точек, прошедших порог
                 % аргумент комплексного числа
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