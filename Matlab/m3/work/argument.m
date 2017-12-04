function angle = argument(BufferFFTw1, BufferFFTw2, energy, EQ64, EQ256)
    angle(1:EQ64,1:EQ256) = 0; 
    for i = 1:EQ64
        for j = 1:EQ256
            if ( energy(i,j) > 0 )
                angle(i,j) = atan( imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j)) ) - atan( imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j)) );
            else
                angle(i,j) = atan( imag(BufferFFTw1(i,j))/real(BufferFFTw1(i,j)) ) - atan( imag(BufferFFTw2(i,j))/real(BufferFFTw2(i,j)) );
            end;            
        end;
    end;
end