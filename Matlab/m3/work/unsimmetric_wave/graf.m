% ��� ��� ������� ���������-�������� (����� ��������� main)

L = 3; % ���������� �� ���������
V = 0.78125; % ���������� �� ��������
[X,Y] = meshgrid(1*L:L:128*L , -31*V:V:32*V);
surfc(X,Y,energy);
%title('������������� ��������� �������� ��������');
title('������������� ����� �� ���������� � ���������');
xlabel('���������, �');
ylabel('������������� ��������, �/�');
zlabel('��������');

% ��� ��� ��������� �������� �������� ������� (����� ��������� signal_script)

% %plot(ZOND);
% plot(1:25000, ZOND, 'blue', 25001:50000, ZOND, 'blue');
% title('����������� ������');
% xlabel('�������, ��');
% ylabel('���������');
% 
% figure
% pwelch(ZOND);
% title('������ ������������ �������');
% 
% figure
% pwelch(S1_RX);
% title('������ ��������� �������');
% 
% figure
% pwelch(S2_RX);
% title('������ ��������� �������');
% 
% figure
% pwelch(S1_SM);
% title('������ ������� �� ������ ���������');
% 
% figure
% pwelch(S2_SM);
% title('������ ������� �� ������ ���������');
% 
% figure
% pwelch(S1);
% title('������ ������������������� �������');
% 
% figure
% pwelch(S2);
% title('������ ������������������� �������');

