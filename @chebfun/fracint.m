function u = fracint(u,alpha)
% FRACINT Fractional integral of a chebfun
%  V = FRACINT(U,ALPHA) computes the fractional integral V of order ALPHA
%  (as defined by the Riemann–Liouville integral) of the chebfun U.
%  
%  If [a b] = domain(U), then V(a) = 0. 
%
%  U may be a quasimatrix, but piecewise chebfuns are not yet supported.
%
%  Example:
%    u = chebfun('s',[0 1]);
%    k = 1;
%    for alpha = 0.1:.1:1
%    k = k + 1;
%    u(:,k) = fracint(u(:,1),alpha);
%        plot(u), drawnow
%    end
%
%  See also chebfun/fracdiff.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: hale $: $Rev: 1017 $:
%  $Date: 2010-01-22 08:53:23 +0000 (Fri, 22 Jan 2010) $:

for k = 1:numel(u)
    u(:,k) = fracintcol(u(:,k),alpha);
end

end

function u = fracintcol(u,alpha)

% Deal with integer parts
for k = 1:alpha
    u = cumsum(u);
end

% Just the fractional part is left
alpha = alpha - floor(alpha);

if alpha == 0 % Nothing to do
    return
end

if u.nfuns > 1,
    error('CHEBFUN:fracint:nfuns','FRACINT and FRACDER do not support piecewise chebfuns');
end

% get ends
ends = get(u,'ends');

% ua = feval(u,a);
% if abs(ua) > u.scl*chebfunpref('eps')
%     warning('CHEBFUN:fracint:zeros', ...
%         'FRACINT and FRACDER assume the chebfun is zero at the left boundary.');
% end

% Get the exponents of u
exps = get(u,'exps');

% fractional kernel
k = @(x,s) (x-s).^(alpha-1);

    % integrand of the operator
    function y = h(x)
        if any(x == ends(1))
            y = NaN;
        else
            y = chebfun(@(s) feval(u,s).*k(x,s),[ends(ends<x) x],'exps',[exps(1) alpha-1],'scale',u.scl);     
%             % playing with piecewise chebfuns            
%             if x <= ends(2)
%                 y = chebfun(@(s) feval(u,s).*k(x,s),[ends(ends<x) x],'exps',[exps(1) alpha-1],'scale',u.scl);            
%             else
%                 y = chebfun(@(s) feval(u,s).*k(x,s),[ends(ends<x) x],'scale',u.scl,'extrapolate',1,'exps',[exps(1) 0 exps(1) alpha-1]);  
%             end
        end
    end

% the result
u = 1./gamma(alpha)*chebfun(@(x) sum(h(x)), ends ,'vectorize','exps',[exps(1,1)+alpha exps(1,2)]);

u.jacobian = anon(' @(u) diff(domain(f),n) * jacobian(f,u)',{'f' 'n'},{u alpha});
u.ID = newIDnum;


end