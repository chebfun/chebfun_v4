function x = bary(x,gvals)
% An implementation of the barycentric formula.
% The function values are store in gvals
% and the function is evaluated at the value(s) in x.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if barymex
    
    % Use precompiled MEX file
    x = bary_mex(x(:),gvals(:));
    
else
    
    % Use this m-file implementation
    n = length(gvals);
    if n==1
        % The function is a constant
        x = gvals*ones(size(x));
        return;
    end
    
    xk = chebpts(n);
    ek = [1/2; ones(n-2,1); 1/2].*(-1).^((0:n-1)');  
    [mem,loc] = ismember(x,xk);
    
    if length(x) < length(xk)
        for i = 1:numel(x)
            if ~mem(i)
                xx = ek./(x(i)-xk);
                x(i) = (xx.'*gvals)/sum(xx);
            end
        end      
    else
         xnew = x(~mem);
         num = zeros(size(xnew)); denom = num;
         for i = 1:numel(xk)
              y = ek(i)./(xnew-xk(i));
              num = num+(gvals(i)*y);
              denom = denom+y;
         end
         x(~mem) = num./denom;
    end
    
    x(mem) = gvals(loc(mem));
    
end