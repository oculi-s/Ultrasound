%% 1. data loading
clear all;
close all;
clc;
data = load('Thyroid.mat');
data = data.Param.Data.BFData;

n_tab = 100;
[fs fc DCR_cutf QDM_cutf SCL_size SCL NSR_cutf] = var_initialize();

%% 2. gray map with color limit
figure(1)
imagesc(db_abs_norm(data));
color_set();
title('1. RAW data');
close 1

%% 3. normal plot & frequency plot of 1st scanline
% figure(2)
% plot(data(:,1))
% figure(3)
% freqz(data(:,1))

%% 4. frequency plot of DC rejection filter
DCR_filter = fir1(n_tab, DCR_cutf, 'high');

% figure(4)
% freqz(DCR_filter)
% figure(5)
% plot(DCR_filter)

%% 5. convolution of DCR filter and data
DCR_data = convn(data, DCR_filter', 'same');
% figure(5)
% freqz(DCR_data(:,1))

%% 6. plotting DC rejected data

figure(6)
imagesc(db_abs_norm(DCR_data));
color_set();
close 6

% for i = 1 : 2064
%     freqz(DCR_data(i,:))
% end

%% 7. initializing QDM filter & separating data
% cosine은 idata 형성, sine은 qdata 형성
% i, q data를 filtering 해주면 envelope이 형성됨
% i : inphase, q : quadratic

t = 1/fs : 1/fs : 1/fs * size(data,1);
temp.cos =  cos(2*pi*fc * t)';
temp.sin =  sin(2*pi*fc * t)';

QDM_filter = fir1(n_tab, QDM_cutf, 'low');

% figure(7)
% freqz(QDM_filter)

%% 8. separated data convolution
% ENV : envelope, 데이터 스무싱 과정
temp.i = convn(DCR_data.*temp.cos, QDM_filter', 'same');
temp.q = convn(DCR_data.*temp.sin, QDM_filter', 'same');
ENV_data = sqrt((temp.i).^2 + (temp.q).^2);

%% 8-1. plotting i, q data
% figure(8)
% imagesc(temp.i);
% color_set();
% 
% figure(9)
% imagesc(temp.q);
% color_set();

%% 8-2. showing difference between envelope data and normal data

figure(10)
DCR_scanline = abs(DCR_data(:,SCL))/max(abs(DCR_data(:,SCL)));
plot(DCR_scanline(SCL_size));
title('DCR scanline');
close 10

figure(11)
ENV_scanline1 = abs(ENV_data(:,SCL)/max(abs(ENV_data(:,SCL))));
plot(ENV_scanline1(SCL_size));
title('ENV scanline : simple QDM');

%% 8-3. applying envelope to image
figure(1)
imagesc(db_abs_norm(ENV_data));
color_set();
title('simple ENV Image');

%% 9. 8 range depthwise QDM
fs = 40 * 10^6;
fc = 7.5 * 10^6;

unit_size = size(data,1) / 8;
t = 1/fs * (1:size(data,1));
temp.cos =  cos(2*pi*fc * t)';
temp.sin =  sin(2*pi*fc * t)';

ENV_range = zeros(size(data));
for i = 1:8
    RAN_size = 1+unit_size*(i-1):unit_size*i;
    RAN_cos = temp.cos(RAN_size);
    RAN_sin = temp.sin(RAN_size);
    temp.i = convn(DCR_data(RAN_size,:).*RAN_cos, QDM_filter', 'same');
    temp.q = convn(DCR_data(RAN_size,:).*RAN_sin, QDM_filter', 'same');
    ENV_range(RAN_size,:) = sqrt((temp.i).^2 + (temp.q).^2);
end

figure(12)
imagesc(db_abs_norm(ENV_range));
color_set();
title('depthwise ENV image');

%% 9-1. problem solving : scanline plot
figure(13)
ENV_scanline = abs(ENV_range(:,SCL)/max(abs(ENV_range(:,SCL))));
plot(ENV_scanline(SCL_size));
title('ENV scanline : range QDM');

figure(14)
plot(abs(ENV_scanline1(SCL_size)-ENV_scanline(SCL_size)))
title('DIFF scanline');

% figure(15)
% plot(abs(ENV_scanline1(SCL_size)./ENV_scanline(SCL_size)))
% title('DIV scanline');

%% 9-2. problem solving : difference plot
figure(16)
ENV_diff = ENV_range - ENV_data;
imagesc(db_abs_norm(ENV_diff));
color_set();
title('DIFF image plot');


%% 9-3. problem solving : Noise reject BSF
NSR_filter = fir1(n_tab, NSR_cutf, 'stop');
NSR_data = convn(ENV_range, NSR_filter', 'same');

figure(17)
imagesc(db_abs_norm(NSR_data));
color_set();
title('Noise Rejected depthwise ENV Image');


%% 9-4. problem solving : difference plot
figure(18)
NSR_diff = ENV_range - NSR_data;
imagesc(db_abs_norm(NSR_diff));
color_set();
title('NSR DIFF image plot');

