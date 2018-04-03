clear

frames_full = load('C:\Users\Ignat\Desktop\DATAS\НАМИ\3\radar\nami3_2017_05_26__10_46_32.mat'); 
frames = frames_full.Array_of_data();
F = 100;

sL  = double(frames(F).data_1canal); % 64*256 с левого канала
sR  = double(frames(F).data_2canal);  % 64*256 с правого канала

B1(1:64,1:256) = 0;
B2(1:64,1:256) = 0;
C1(1:256,1:64) = 0;
C2(1:256,1:64) = 0;

for i = 1:64
    B1(i,:) = fft(sL(i,:));
    B2(i,:) = fft(sR(i,:));
end;

B1 = B1';
B2 = B2';

sL = sL';
sR = sR';

for i = 1:64
    C1(:,i) = fft(sL(:,i));
    C2(:,i) = fft(sR(:,i));
end;

A1 = fft(sL);
A2 = fft(sR);

colormap(jet);
subplot(1,3,1);pcolor(abs(A1)+abs(A2));
subplot(1,3,2);pcolor(abs(B1)+abs(B2));
subplot(1,3,3);pcolor(abs(B1)+abs(B2));