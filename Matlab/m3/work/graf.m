plot(ZOND);
title('����������� ������');
xlabel('�������, ��');
ylabel('���������');

figure
pwelch(ZOND);
title('������ ������������ �������');

figure
pwelch(S1_RX);
title('������ ��������� �������');

figure
pwelch(S2_RX);
title('������ ��������� �������');

figure
pwelch(S1_SM);
title('������ ������� �� ������ ���������');

figure
pwelch(S2_SM);
title('������ ������� �� ������ ���������');

figure
pwelch(S1);
title('������ ������������������� �������');

figure
pwelch(S2);
title('������ ������������������� �������');




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
% title('����������� ������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(ZOND_g);
% title('������ ������������ �������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S1_RX_g);
% title('������ ��������� �������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S2_RX_g);
% title('������ ��������� �������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S1_SM_g);
% title('������ ������� �� ������ ���������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S2_SM_g);
% title('������ ������� �� ������ ���������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S1_g);
% title('������ ������������������� �������');
% xlabel('�������, ��');
% ylabel('���������, �');
% 
% figure
% semilogx(S2_g);
% title('������ ������������������� �������');
% xlabel('�������, ��');
% ylabel('���������, �');