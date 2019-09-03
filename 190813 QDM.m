tab = 100;
fs = 40 * 10^6;
fc = 7.5 * 10^6;

filter = fir1(tab, [0.4 0.6], 'bandpass');

t = (1:tab+1)*1/fs;
filcos = filter.*cos(2*pi*fc * t);
filsin = filter.*sin(2*pi*fc * t);

filter2 = fir1(tab, 0.3, 'low');
filcos2 = convn(filcos, filter2, 'same');
filsin2 = convn(filsin, filter2, 'same');

figure(1);
freqz(filter);
figure(3);
freqz(filcos2);
figure(5);
freqz(filsin2);

% figure(2);
% plot(filter);
% figure(4);
% plot(filcos2);
% figure(6);
% plot(filsin2);