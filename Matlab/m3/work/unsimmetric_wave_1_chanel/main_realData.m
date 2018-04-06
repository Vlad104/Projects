clear

EQ256 = 256;      % число, эквивалентное 256
EQ128 = EQ256/2;  % число, эквивалентное 256/2
EQ64 = 64;        % число, эквивалентное 64
RN = 50;          % кол-во рассматриваемых отсчетов по дальности

Rd = 3;  %разрешение по дальности
Vd = 0.78125; %разрешение по скорости

frames_full = load('C:\Users\Ignat\Desktop\DATAS\НАМИ\3\radar\nami3_2017_05_26__10_46_32.mat'); 
frames = frames_full.Array_of_data();
len=length(frames(1,:)); %размер данных
start = 150;

for F = start:len
    
    sL  = double(frames(F).data_1canal);  % 64*256 с левого канала
    sR  = double(frames(F).data_2canal);  % 64*256 с правого канала
  
    W1 = processing_noFilter(sL, sR, EQ64, EQ256, RN);
    W2 = processing(sL, sR, EQ64, EQ256,RN);
    W3 = processing_withCorrection(sL, sR, EQ64, EQ256,RN);

     %координатная сетка для построения графиков
    ax = Rd:Rd:RN*Rd;    
    ay = -31*Vd:Vd:32*Vd;

    colormap(jet);
    subplot(1,3,1);pcolor(ax,ay, W1);
    subplot(1,3,2);pcolor(ax,ay, W2);
    title(['Номер кадра: ', num2str(F)]);
    subplot(1,3,3);pcolor(ax,ay, W3);
    %F
    %xlabel('Дальность, м');
    %ylabel('Относительная скорость, м/с');
    %zlabel('Мощность');   
    
    pause(0.01);
end
