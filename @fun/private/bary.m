function out = bary(x,gvals)
% An implementation of the barycentric formula.
% The function values are store in gvals
% and the function is evaluated at the value(s) in x.
n = length(gvals);
if n==1
    out = gvals*ones(size(x));
    return
end
xk = chebpts(n)';
sizex = size(x);
x = x(:);
[mem,loc] = ismember(x,xk);
out = zeros(sizex);
out(find(mem)) = gvals(loc(find(mem)));
pos = find(1-mem); s = length(pos);
ek = [1/2 ones(1, n-2) 1/2].*(-1).^((0:n-1));
xx = ek(ones(s,1),:)./(x(pos,ones(1,n))-xk(ones(s,1),:));
out(pos) = (xx*gvals)./sum(xx,2);