%BINLOG1
clear all
ffilename = 'C:\Users\Ignat\Desktop\DATAS\НАМИ\2\radar\nami22017_05_24__16_03_39';
fileID = fopen([ffilename,'.binlog'],'rb'); % opens an existing file for reading
if fileID == -1                     % checking the correctness of opening a file
    error('File is not opened');
end

Array_of_data.second=[];
Array_of_data.nanosecond=[];
Array_of_data.data_1canal=zeros(64,256);
Array_of_data.data_2canal=zeros(64,256);

state = 0; %Состояние автомата расшифровки пакета
counter_AA = 0; %Счетчик преамбулы
flag_channel = 0; %Флаг приемного канала (0, 1)
counter_data = 0; %Счетчик для дешифрации данных
correct_data = 0; %Флаг получения корректного пакета (0, 1)
k = 1; %Счетчик переменных в матрице данных
j = 1; %Счетчик записей в структуре

BINLOG1=fread(fileID,[1,7],'*char'); %Reads special header from an open binary file=-
if (strcmp('BINLOG1',BINLOG1)==1) %check special header 'BINLOG1
    while ~feof(fileID)
        
        indif=int32(fread(fileID,1,'int32')); %индификатор
        if (indif ~= 2) %неверный идентификатор
            error('File is corrupted');
        end;
        if (size(indif) == 0) % если пустые данные, то достигнут конец файла
            break;
        end;
        size_of_data=uint32(fread(fileID,1,'uint32')); %размер данных
        second=int32(fread(fileID,1,'int32'));        %секунды
        nanosecond=int32(fread(fileID,1,'int32'));    %наносекунды
        buff = uint8(fread(fileID,size_of_data,'uint8')); %пакет данных
        for i=1:1:size_of_data
            switch state
                case 0 %Прием преамбулы
                    if (buff(i) == 170)
                        counter_AA = counter_AA + 1;
                        if (counter_AA == 5) %Если подряд 5 байтов АА
                            if (correct_data == 1) %Если предудщий пакет был получен полностью, то копирование его в структуру
                                Array_of_data(j).second=second;
                                Array_of_data(j).nanosecond=nanosecond;
                                for ii=1:1:64
                                    Array_of_data(j).data_1canal(ii,:)=buff_chanel_left((ii-1)*256+1:ii*256);
                                    Array_of_data(j).data_2canal(ii,:)=buff_chanel_right((ii-1)*256+1:ii*256);
                                end;
                                j = j+1;
                            end;
                            counter_AA = 0;
                            state = 1; %переход в состояние приема данных
                            data = uint16(0);
                        end;
                    else
                        counter_AA = 0;
                        correct_data = 0;
                        data = uint16(0);
                    end;
                case 1 %Прием данных
                    data = data + uint16(uint16(buff(i))*2^(8*counter_data)); %формирование 2-х байтного числа
                    counter_data = counter_data + 1;
                    if (counter_data == 2)
                        if(flag_channel == 0) %последовательная запись в 1-й и 2-й канал
                            buff_chanel_left(k) = data;
                            flag_channel = 1;
                        else
                            buff_chanel_right(k) = data;
                            flag_channel = 0;
                            k = k + 1;
                            if (k > 256*64) %Если формирование матрицы завершено
                                correct_data = 1; %установка флага корректности принятой матрицы
                                state = 0; %переход в состояние приема преамбулы
                                k = 1;
                            end;
                        end
                        counter_data = 0;
                        data = uint16(0);
                    end;
                    if (buff(i) == 170) %отслеживание прихода преамбулы раньше времени
                        counter_AA = counter_AA + 1;
                        if (counter_AA == 5) %Если подряд 5 байтов АА
                            k = 1;
                            correct_data = 0;
                            counter_AA = 0;
                            state = 1; %переход в состояние приема данных
                            data = uint16(0);
                        end;
                    else
                        counter_AA = 0;
                    end;
            end;
        end;
    end;
end;

if (correct_data == 1) %Запись последней матрицы в файле, если она корректна
    Array_of_data(j).second=second;
    Array_of_data(j).nanosecond=nanosecond;
    for ii=1:1:64
        Array_of_data(j).data_1canal(ii,:)=buff_chanel_left((ii-1)*256+1:ii*256);
        Array_of_data(j).data_2canal(ii,:)=buff_chanel_right((ii-1)*256+1:ii*256);
    end;
end;

fclose(fileID); %Closes the file specified by the file descriptor fileID.

save([ffilename,'.mat'], 'Array_of_data');