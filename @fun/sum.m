function out = sum(g)
% SUM	Definite integral from -1 to 1
% SUM(G) is the integral from -1 to 1 of F.  

if isempty(g), out = g; return, end
n = g.n;
if (n==1), out=g.vals*2; return; end
c = chebpoly(g);
c = c(end:-1:1);
c(2:2:end) = 0;
out = (c'*[2 0 2./(1-((2:n-1)).^2)]').';