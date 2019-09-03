%% 1. data load & initialize
cd \users\user\desktop\ultrasound

clear all;
close all;
clc;
data = load('Thyroid.mat');
data = data.Param.Data.BFData;

w = 500;
tab = 64;
DCR_bw = 0.05;
%% 2. gray map with color limit
figure(1)
SETP(0, 0, 1);
imagesc(DB_ABS_NORM(data)); COLOR_SET;
title('1. RAW data');
close;

DCR_filter = fir1(tab, DCR_bw, 'high');
DCR_data = convn(data, DCR_filter', 'same');

figure(2)
SETP(1, 0, 1);
imagesc(DB_ABS_NORM(DCR_data)); COLOR_SET;
title('1. DCR data');
% close;

%% 3. X2 interpolation
INT2_data = zeros(size(data,1), size(data,2)*2);
INT2_data(:,2:2:end) = DCR_data;

figure(3)
SETP(5, 0, 1);
imagesc(DB_ABS_NORM(INT2_data)); COLOR_SET;
title('2. zero padded data');
% close;

INT_filter = fir1(tab, 1/8, 'low');
H0 = INT_filter(1:16:end);


INT2_data = convn(INT2_data, INT_filter(1:4:end), 'same');

figure(4)
SETP(2, 0, 1);
imagesc(DB_ABS_NORM(INT2_data)); COLOR_SET;
title('3. X2 interpolation');
% close;

%% 4. X4, X8 interpolation
INT4_data = zeros(size(data,1), size(data,2)*4);
INT4_data(:,2:4:end) = DCR_data;
INT4_data = convn(INT4_data, INT_filter(1:2:end), 'same');

figure(5)
SETP(1, -1, 1);
imagesc(DB_ABS_NORM(INT4_data)); COLOR_SET;
title('4. X4 interpolation');
% close;

INT8_data = zeros(size(data,1), size(data,2)*8);
INT8_data(:,2:8:end) = DCR_data;
INT8_data = convn(INT8_data, INT_filter, 'same');

figure(6)
SETP(2, -1, 1);
imagesc(DB_ABS_NORM(INT8_data)); COLOR_SET;
title('5. X8 interpolation');
% close;

