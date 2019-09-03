function SETP(x1, y1, w1)
w = 500;
x = 0;
y = 400;

set(gcf, 'Position', [x+w*x1 y+w*0.8*y1-100 w*w1 w*0.8]);
end