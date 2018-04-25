F = 10e-8;
for i = 1:64
    %sigma(i) = std(W3(i,:)); % sqrt(sum((a(:) - mean(a)).^2)/7)
    sigma(i) = 3*mean(std(W3'));
    pE(i) = sigma(i)*sqrt(-2*log(F)); 
end;
% sigma = 86+804;
% E = sigma*sqrt(-2*log(F));
% pE(1:64) = E;
% figure
% plot(W3(:, 19));
plot(1:64, pE, 'red', 1:64, W3, 'blue');
%plot(sigma)