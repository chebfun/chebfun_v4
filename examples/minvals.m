function minvals = minvals(u,x,y)
minvals = 0*y;
for i = 1:length(y)
    minvals(i) = min(u(x,y(i)));
end
