%% 1. data load & initialize
cd \users\user\desktop\ultrasound

clear all;
close all;
clc;
data = load('Thyroid.mat');
data = data.Param.Data.BFData;

tab = 32;
DCR_bw = 0.05;
QDM_bw = 0.3;
INT_bw = 1/16;
fs = 40*10^6;
fc = 7.5*10^6;

DCR_filter = fir1(tab, DCR_bw, 'high');
QDM_filter = fir1(tab, QDM_bw, 'low');
INT_filter = fir1(tab,INT_bw,'low');

data = convn(data, DCR_filter, 'same');
t = 1/fs * (1:size(data,1));
idata = convn(data.*cos(2*pi*fc * t)', QDM_filter', 'same');
qdata = convn(data.*sin(2*pi*fc * t)', QDM_filter', 'same');
data = sqrt((idata).^2 + (qdata).^2);

clear tab DCR_bw QDM_bw INT_bw fs fc t idata qdata;

%% 2. rectangular convesion
SIZE.RAW = size(data);
SIZE.RECT = [800 600]; % WIDTH, HEIGHT
SIZE.PHAS = [2064 100]; % RADIUS, ANGLE

DATA.RAW = data;
DATA.RECT = RECT_SET(data,SIZE);
DATA.PHAS = PHAS_SET(data,SIZE);

figure(1);
SETP(0, 0, 1);
imagesc(DB_ABS_NORM(DATA.RAW)); COLOR_SET;
title('1. ENV data');
% close;

figure(2);
SETP(0, -0.1, 1);
imagesc(DB_ABS_NORM(DATA.RECT)); COLOR_SET;
title('2. RECT data');
% close;

figure(3);
SETP(1, 0, 2);

DATA.PHAS = convn(DATA.PHAS, INT_filter, 'same');
imagesc(DB_ABS_NORM(DATA.PHAS)); COLOR_SET;
title('3. PHAS data');
