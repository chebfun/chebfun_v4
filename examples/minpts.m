function minpts = minpts(u,x,y)
minpts = 0*y;
for i = 1:length(y)
    [tmp minpts(i)] = min(u(x,y(i)));
end