F = 10e-8;
for i = 1:64
    sigma(i) = std(AA(i,:)); % sqrt(sum((a(:) - mean(a)).^2)/7)
    X0(i) = sigma(i)*sqrt(-2*log(F)); 
end;
% sigm = std(sL');
% plot(X0);
% figure
% plot(W3(:, 19));
plot(1:64, X0,'red', 1:64, W3, 'blue');
%plot(sigma)