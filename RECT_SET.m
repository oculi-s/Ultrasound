function RECT = RECT_SET(data,SIZE)
    X = SIZE.RAW(1)/SIZE.RECT(1)*(1:SIZE.RECT(1));
    Y = SIZE.RAW(2)/SIZE.RECT(2)*(1:SIZE.RECT(2));
    RECT = data(round(mean([ceil(X); floor(X)],1)),round(mean([ceil(Y); floor(Y)],1)));
end