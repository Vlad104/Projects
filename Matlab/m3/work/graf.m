plot(ZOND);
title('Зондирующий сигнал');
xlabel('Частота, Гц');
ylabel('Амплитуда');

figure
pwelch(ZOND);
title('Спектр зондирующего сигнала');

figure
pwelch(S1_RX);
title('Спектр принятого сигнала');

figure
pwelch(S2_RX);
title('Спектр принятого сигнала');

figure
pwelch(S1_SM);
title('Спектр сигнала ны выходе смесителя');

figure
pwelch(S2_SM);
title('Спектр сигнала ны выходе смесителя');

figure
pwelch(S1);
title('Спектр дискретизированного сигнала');

figure
pwelch(S2);
title('Спектр дискретизированного сигнала');




% ZOND_g = abs(fft(ZOND));
% S1_RX_g = abs(fft(S1_RX));
% S2_RX_g = abs(fft(S2_RX));
% S1_SM_g = abs(fft(S1_SM));
% S2_SM_g = abs(fft(S2_SM));
% S1_g = abs(fft(S1));
% S2_g = abs(fft(S2));
% 
% ZOND_g(25000/2+1:25000,:) = [];
% S1_RX_g(25000/2+1:25000,:) = [];
% S2_RX_g(25000/2+1:25000,:) = [];
% S1_SM_g(25000/2+1:25000,:) = [];
% S2_SM_g(25000/2+1:25000,:) = [];
% S1_g(256/2+1:256,:) = [];
% S2_g(256/2+1:256,:) = [];
% 
% plot(ZOND);
% title('Зондирующий сигнал');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(ZOND_g);
% title('Спектр зондирующего сигнала');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S1_RX_g);
% title('Спектр принятого сигнала');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S2_RX_g);
% title('Спектр принятого сигнала');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S1_SM_g);
% title('Спектр сигнала ны выходе смесителя');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S2_SM_g);
% title('Спектр сигнала ны выходе смесителя');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S1_g);
% title('Спектр дискретизированного сигнала');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');
% 
% figure
% semilogx(S2_g);
% title('Спектр дискретизированного сигнала');
% xlabel('Частота, Гц');
% ylabel('Амплитуда, В');