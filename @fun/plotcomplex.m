function plotcomplex(g,m,linespec)

h=ishold;
m2 = g.n;
gv=prolong(g,m2);
g=prolong(g,m);

marker = linespec{4}; linespec{4} = 'none';
plot(real(g.val),imag(g.val),linespec{1:end});
linespec{4} = marker;
if ~strcmp(marker,'none')
    linespec{2} = 'none'; % set linestyle to 'none'
    hold on
    plot(real(gv.val),imag(gv.val),linespec{1:end});
    hold off
end
if h, hold on; else hold off; end