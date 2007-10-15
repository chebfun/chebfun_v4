function plot(f,g,m,linespec)
% PLOT	Linear fun plot
% PLOT(F,G) plots fun G versus fun F.
%
% PLOT(F,'.-') plots the fun F and shows the function values at
% the Chebyshev points.
%
% PLOT also supports the usual string argument that controls the way the
% graph is displayed.

h=ishold;
if g.n == 0, 
    m2 = 0; % fix plot(chebfun(1),'.-')
else
    m2=max(f.n,g.n);
end
fv=prolong(f,m2);
gv=prolong(g,m2);
f=prolong(f,m);
g=prolong(g,m);
t=cheb(m);
if not(isreal(g.val))
    marker = linespec{4}; linespec{4} = 'none';
    plot(real(g.val),imag(g.val),linespec{1:end});
    linespec{4} = marker;
    if ~strcmp(marker,'none')
        linespec{2} = 'none'; % set linestyle to 'none'
        hold on
        plot(real(gv.val),imag(gv.val),linespec{1:end});
        hold off
    end
else
    marker = linespec{4}; linespec{4} = 'none';
    plot(f.val,g.val,linespec{1:end});
    linespec{4} = marker;
    if ~strcmp(marker,'none')
        linespec{2} = 'none'; % set linestyle to 'none'
        hold on
        plot(fv.val,gv.val,linespec{1:end});
        hold off
    end
end
if h, hold on; else hold off; end
