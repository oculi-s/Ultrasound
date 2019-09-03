close all;
clear all;
clc;

tab = 500;
w = 360;
h = 0.8*w;
offset = 50;

H0 = fir1(tab, 0.2, 'low');
figure(1);
set(gcf, 'Position', [offset 500 w h]);
plot(H0);
figure(2);
set(gcf, 'Position', [offset+w 500 w h]);
freqz(H0);

H0(1:2:end) = 0;
figure(3);
set(gcf, 'Position', [offset+2*w 500 w h]);
freqz(H0);

H0(1:2:end) = 0;
figure(4);
set(gcf, 'Position', [offset+3*w 500 w h]);
freqz(H0);