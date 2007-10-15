function semilogy(f,varargin)

vals = chebvals(f);
m=max(2000,2*length(vals));
f=prolong(f,m);
t=chebgrid(f);
y=chebvals(f);
semilogy(t,y,varargin{:});
axis auto