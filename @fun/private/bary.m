function x = bary(x,f)
% An implementation of the barycentric formula.
% The function values are store in f
% and the function is evaluated at the value(s) in x.
n = length(f)-1;
if n==0
    % The function is a constant
    x = f*ones(size(x));
else
    xk = cos(pi*(0:n)/(n))';
    ek = [1/2; ones(n-1,1); 1/2].*(-1).^((0:n)');
    mem = ismember(x,xk);
    for i = 1:numel(x)
        if (mem(i))
            x(i) = f(xk==x(i));
        else
            xx = ek./(x(i)-xk);
            %x(i) = (sum(xx.*f))/sum(xx);        % most readable
            x(i) = (xx.'*f)/sum(xx);             % faster
        end
    end
end