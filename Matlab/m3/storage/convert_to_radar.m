%clear
%load('C:\Users\Ignat\Desktop\DATAS\Õ¿Ã»\3\radar\nami3_2017_05_26__12_29_13.mat');
%gps_data = dlmread('C:\Users\Ignat\Desktop\DATAS\Õ¿Ã»\read_write\FILE0040_GPS.csv',';');
%gps_data = readtable('C:\Users\Ignat\Desktop\DATAS\Õ¿Ã»\read_write\FILE0040_GPS.csv');
time_vector = gps_data.Var2;
speed_vector = gps_data.Var7;