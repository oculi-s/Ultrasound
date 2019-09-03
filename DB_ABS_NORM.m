function y = DB_ABS_NORM(x)
	y = db(abs(x)/max(abs(x(:))));
end