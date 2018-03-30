function Y = DFT(X,N)
Y(1:N) = 0;
im = sqrt(-1);
for k = 0:N-1
    for n = 0:N-1
        Y(k+1) = Y(k+1) + X(n+1)*exp(-2*pi*im*k*n/N);
    end
end