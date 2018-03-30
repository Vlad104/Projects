clear all
frames_full = load('C:\Users\Ignat\Desktop\DATAS\НАМИ\3\radar\nami3_2017_05_26__10_46_32.mat'); 
frames = frames_full.Array_of_data();
%frames содержит структуру со след. полями: second, nanosecond, metka, data_1canal, data_2canal.
len=length(frames(1,:)); %размер данных
a = [0.92703707226149745000, -0.92703707226149745000]; %значения коэффициентов фильтра
b = [1.00000000000000000000, -0.85408068546991278000];
N = 64; %количество строк в массиве данных
M = 256; %количество столбцов в массиве данных
K = 50; %количество отсчетов по дальности
L = 32; %количество убираемых отсчетов перед первым БПФ
k_min = 10; % коэффициент порога
k_max = 2;
n_look = 16; % колличество обозреваемых точек 
n_miss = 1; % колличество пропускаемых точек
Rd = 3;  %разрешение по дальности
Vd = 0.78125; %разрешение по скорости
ax = Rd:Rd:K*Rd;
ay = (-N/2+1)*Vd:Vd:N/2*Vd;
%s_out_L = zeros(64, 256);  %данные после фильтрации
%s_out_R = zeros(64, 256);
%s_out_L_64_224=zeros(64, 224); %после фильтрации из каждого периода убраны 32 отсчета
%s_out_R_64_224=zeros(64, 224);
%s_out_L_64_50=zeros(64, 50); %данные после первого преобразования Фурье с усечением дальности
%s_out_R_64_50=zeros(64, 50);


for F = 1:1:len % считываем по кадрам
    BufferFFTt1 = [];
    BufferFFTt2 = [];
    BufferFFTw1 = [];
    BufferFFTw2 = [];
    
    sL  = double(frames(F).data_1canal); % 64*256 с левого канала
    sR = double(frames(F).data_2canal);  % 64*256 с правого канала
    
    for i=1:N % фильтрация
        s_out_L(i,:) = filter(a,b,sL(i,:)); 
        s_out_R(i,:) = filter(a,b,sR(i,:));
    end;

    for i=1:N % убираем первые L отсчета
        s_out_L_224_64(i,:)=s_out_L(i,L+1:256);
        s_out_R_224_64(i,:)=s_out_R(i,L+1:256);
    end;
      
    w=hamming(M-L); % окно Хэмминга
     for i=1:N %свертка с окном
        for j=1:M-L
            BufferIn1(i,j)=s_out_L_224_64(i,j).*w(j);
            BufferIn2(i,j)=s_out_R_224_64(i,j).*w(j);
        end;
     end;

    % БПФ по "быстрому времени"
    for i=1:N
        BufferFFTt1(i,:) = fft(BufferIn1(i,:));
        BufferFFTt2(i,:) = fft(BufferIn2(i,:));
    end;
   
    % усечение массива после 1-го преобразования Фурье
    for i=1:N
        s_out_L_64_50(i,:)=BufferFFTt1(i,1+2:K+2);
        s_out_R_64_50(i,:)=BufferFFTt2(i,1+2:K+2);
    end;   
    
    % операция транспонирования матрицы
    BufferFFTt1 = s_out_L_64_50';
    BufferFFTt2 = s_out_R_64_50';
    
    w=hamming(N); % окно Хэмминга
     for i=1:K %свертка с окно
        for j=1:N
            BufferFFTt1(i,j)=BufferFFTt1(i,j).*w(j);
            BufferFFTt2(i,j)=BufferFFTt2(i,j).*w(j);
        end;
     end;

    % БПФ по "медленному времени"
    for i=1:K
        BufferFFTw1(i,:) = fft(BufferFFTt1(i,:));
        BufferFFTw2(i,:) = fft(BufferFFTt2(i,:));
    end;
    
    %обратное транспонирование    
    BufferFFTw1=BufferFFTw1';
    BufferFFTw2 =BufferFFTw2';
    
    %приведение матрицы к стандартному виду
    out1(1:N/2,:) = BufferFFTw1(N/2:-1:1,:);
    out1(N/2+1:N,:) = BufferFFTw1(N:-1:N/2+1,:);
    out2(1:N/2,:) = BufferFFTw2(N/2:-1:1,:);
    out2(N/2+1:N,:) = BufferFFTw2(N:-1:N/2+1,:);
        
    % расчет мощности в каждой точке (сумма модулей соответствующих двух чисел)
    energy0 = abs(out1) + abs(out2);
 
    [out1_n, out2_n] = PrepDataNew(sL, sR, a, b);
    energy1 = abs(out1_n) + abs(out2_n);

    % пороговая фильтрация
    %energy = threshold_filter(energy1, k_min, k_max, EQ64, 50, n_look, n_miss);
    
    %energy = threshold_filter2(energy1, 10, k_max, EQ64, 50, n_look, n_miss);

    % расчет угла
   % arg = argument(BufferIn1, BufferIn2, energy, EQ64, 50/2);

    % кластеризация и заполнение структуры
    % нулевая скорость в 32 строке energy -> 64 строка неинформативна
   % Struct = clustering(energy, energy1, arg, Rd, Vd, EQ64, 50/2);
   
    
%     %[X,Y] = meshgrid(ax ,ay);
    %surfc(X,Y,energy1);
%    surfc(energy1);
    colormap(jet);
    %image (ax,ay,energy1)
    subplot(1,2,1);pcolor(ax,ay, energy0); %hold on%shading interp%image(ax,ay, energy0, 'CDataMapping' , 'scaled' ); %hold on
    subplot(1,2,2);pcolor(ax,ay, energy1); %hold on%shading interp%image(ax,ay, energy1, 'CDataMapping' , 'scaled' ); %hold on
    %image(ax,ay, energy1, 'CDataMapping' , 'scaled' )
    %image(BufferIn1', 'CDataMapping' , 'scaled' )
    %hold on
%     %image(energy1, 'CDataMapping' , 'scaled' );
%     %title('Матрица дальность - скорость');
    title(['Номер кадра: ', num2str(F)]);
    xlabel('Дальность, м');
    ylabel('Относительная скорость, м/с');
    zlabel('Мощность');
    pause(0.01)
    %W(F,:,:) = energy1;
    %SS(F) = Struct;
end;
