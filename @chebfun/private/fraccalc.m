function u = fraccalc(u,alpha)
% FRACCALC Fractional calculus of a chebfun
%  FRANCCALC(U,N) is called by DIFF(U,N) and CUMSUM(U,N) when N is not an
%  integer and computes the fractional integral of order ALPHA
%  (as defined by the Riemann–Liouville integral) of the chebfun U.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%  Copyright 2002-2009 by The Chebfun Team. 

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

% ua = feval(u,ends(1));
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
        if any(x == ends)
            y = chebfun(NaN,[ends(1),x]);
        else
            y = chebfun(@(s) feval(u,s).*k(x,s),[ends(ends<x) x],'exps',[exps(1) alpha-1],'scale',u.scl);     
            
%             % playing with piecewise chebfuns  
%             newends = [ends(ends<x) x];
%             newexps = [];
%             for l = 1:length(newends)-1
%                 newexps = [newexps exps(l,1) 0];
%             end
%             newexps(end) = alpha-1;
%             y = chebfun(@(s) feval(u,s).*k(x,s),newends,'exps',newexps,'scale',u.scl,'extrapolate',1,'splitting','on');  

        end
    end

newexps = exps(:).'; 
newexps(1) = newexps(1)+alpha;

% the result
u = 1./gamma(alpha)*chebfun(@(x) sum(h(x)), ends ,'vectorize','exps',newexps);

% jacobian data
u.jacobian = anon(' @(u) diff(domain(f),n) * jacobian(f,u)',{'f' 'n'},{u alpha});
u.ID = newIDnum;

end