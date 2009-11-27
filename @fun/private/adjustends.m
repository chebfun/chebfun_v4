function xvals = adjustends(xvals,a,b)
% Fix endpoints if 2nd kind points are used
if isinf(a)
    xvals(1) = -1e20;
else
    xvals(1) = a;    
end
if isinf(b)
    xvals(end) = 1e20;
else
    xvals(end) = b;
end