f = chebfun('sin(pi*x)');
s = f;
for j = 1:10
    f = (3/4)*(1 - 2*f.^4);
    s = s + f;
end
plot(s)

r = roots(s-5)
hold on, plot(r,s(r),'r*')
sum(s)
[mx,sx] = max(s);
[mn,sn] = min(s);

plot(sx,mx,'ok');
plot(sn,mn,'ok');