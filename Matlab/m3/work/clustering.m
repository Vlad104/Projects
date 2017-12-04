function Struct = clustering(energy, energy0, angle, EQ64, EQ256)
    Struct(1:int32(EQ64*EQ256/2),1:6) = 0; % 1- номер обл, 2-сумм мощность, 3-дальность, 4- скор, 5 - угол, 6 - кол-во точек (не нужно)
    Mark(1:EQ64,1:EQ256) = 0;
    Stack(1:EQ256/4*EQ64/4,1:2) = 0;
    struct_size = 1;
    BB = energy;
    for ii = 1 : EQ64
        for jj = 1 : EQ256
            stack_pointer = 1;
            i = ii;
            j = jj;
            flag = 0; %first IN from this point
            while ( stack_pointer > 0 )
                if flag %if not first times in while
                    i = Stack(stack_pointer,1);
                    j = Stack(stack_pointer,2);
                end;
                flag = 1;          

                if ( j <= EQ256 && i <= EQ64 && Mark(i,j) == 0 && energy(i,j) > 0 )

                    Struct(struct_size,1) = struct_size;
                    Struct(struct_size,2) = Struct(struct_size,2) + energy0(i,j);                
                    Struct(struct_size,3) = Struct(struct_size,3) + j*energy0(i,j);
                    Struct(struct_size,4) = Struct(struct_size,4) + (i - EQ64/2)*energy0(i,j);                
                    Struct(struct_size,5) = Struct(struct_size,5) + angle(i,j)*energy0(i,j);
                    Struct(struct_size,6) = Struct(struct_size,6) + 1; %dont need

                    Mark(i,j) = 1;
                    BB(i,j) = struct_size;                
                    stack_pointer = stack_pointer - 1;

                    if ( j + 1 <= EQ256 && Mark(i, j+1) == 0 && energy(i, j+1) > 0 )
                        stack_pointer = stack_pointer + 1;
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j+1;
                    end;

                    if ( j - 1 >= 1 && Mark(i, j-1) == 0 && energy(i, j-1) > 0 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i;
                        Stack(stack_pointer,2) = j-1;
                    end;

                    if ( i + 1 <= EQ64 && Mark(i+1, j) == 0 && energy(i+1, j) > 0 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i+1;
                        Stack(stack_pointer,2) = j;
                    end;

                    if ( i - 1 >= 1 && Mark(i-1, j) == 0 && energy(i-1, j) > 0 )
                        stack_pointer = stack_pointer + 1; 
                        Stack(stack_pointer,1) = i-1;
                        Stack(stack_pointer,2) = j;
                    end;
                else
                    break;
                end;
            end;
            if (Struct(struct_size,2) > 0)
                struct_size = struct_size + 1;
            end;
        end;
    end;

    for i = 1:int32(EQ64*EQ256/2)
        if (Struct(struct_size,2) > 0)
            Struct(i,3) = Struct(i,3)/Struct(i,2);
            Struct(i,4) = Struct(i,4)/Struct(i,2);
            Struct(i,5) = Struct(i,5)/Struct(i,2);
        end;
    end;
end