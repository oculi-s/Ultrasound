function PHAS = PHAS_SET(data,SIZE)
    R = SIZE.PHAS(1)/SIZE.RAW(1)*(1:SIZE.RAW(1));
    A = SIZE.PHAS(2)/SIZE.RAW(2)*(1:SIZE.RAW(2))-SIZE.PHAS(2)/2;
    A = A*pi/180;
    O = [R(end)/2 abs(R(end)*sin(A(end)))];
    PHAS = zeros(R(end),round(R(end)*sin(A(end))));
    
    for i = 1:length(A)
        X = 1+cos(A(i))*R;
        Y = O(2)+sin(A(i))*R;
        for j = 1:length(R)
            PHAS(1+round(X(j)),1+round(Y(j))) = data(j,i);
        end
    end
end