function arg = geometric(BufferIn1, BufferIn2, energy, EQ64, EQ256)

    l = 3e8/24e9;
    arg(1:EQ64,1:EQ256) = 0;  % создание массива с нулями 
    
    for i = 1:EQ64
        for j = 1:EQ256
            if ( energy(i,j) > 0 ) % для точек, прошедших порог
                R1 = abs(BufferIn1(i,j));
                R2 = abs(BufferIn1(i,j));
                A = acos( (R1^2 + R2^2 + 4*l^2)/(2*R1*R2));
                arg(i,j) = ( l + R2/sin(alfa)*sqrt(2 - 2*cos(alfa)) )/( R2*sqrt(1 - sin(alfa)^2/(2 - 2*cos(alfa))) );                             
            else
                arg(i,j) = 0;
            end;            
        end;
    end;
end