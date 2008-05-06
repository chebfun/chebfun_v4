function x = bary(x,gvals)
% An implementation of the barycentric formula.
% The function values are store in gvals
% and the function is evaluated at the value(s) in x.

n = length(gvals);
if n==1
    % The function is a constant
    x = gvals*ones(size(x));
    return;
end
xk = chebpts(n);
ek = [1/2; ones(n-2,1); 1/2].*(-1).^((0:n-1)');
mem = ismember(x,xk);
for i = 1:numel(x)
    if (mem(i))
        x(i) = gvals(xk==x(i));
    else
        xx = ek./(x(i)-xk);
        x(i) = (xx.'*gvals)/sum(xx);
    end
end