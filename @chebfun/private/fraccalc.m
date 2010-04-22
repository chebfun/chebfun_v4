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

function v = fracintcol(u,alpha)

% Deal with integer parts
for k = 1:alpha
    u = cumsum(u);
end

% Just the fractional part is left
alpha = alpha - floor(alpha);

if alpha == 0 % Nothing to do
    v = u;
    return
end

% if u.nfuns > 1,
%     error('CHEBFUN:fracint:nfuns','FRACINT and FRACDER do not support piecewise chebfuns');
% end

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
        if any(x == ends(1))
            y = chebfun(0,[ends(1),ends(1)]);
        elseif any(x == ends(2:end))
            y = chebfun(NaN,[ends(1),x]);
        else
%             y = chebfun(@(s) feval(u,s).*k(x,s),[ends(ends<x) x],'exps',[exps(1) alpha-1],'scale',u.scl) 
            
            % playing with piecewise chebfuns  
            newends = [ends(ends<x) x];
            tmpexps = [];
            for l = 1:length(newends)-1
                tmpexps = [tmpexps exps(l,1) 0];
            end
            tmpexps(end) = alpha-1;
            y = chebfun(@(s) feval(u,s).*k(x,s),newends,'exps',tmpexps,'scale',u.scl,'extrapolate',1,64);

        end
    end

newexps = exps;
newexps(1) = exps(1)+alpha;
newends = ends;

% the result
v = 1./gamma(alpha)*chebfun(@(x) sum(h(x)), newends ,'vectorize','exps',newexps,'maxdegree',64);

% diff data
v.jacobian = anon(' @(u) diff(domain(f),n) * diff(f,u)',{'f' 'n'},{u alpha});
v.ID = newIDnum;

return

    % integrand of the operator
    function y = h0(x)
        if any(x == 0)
            y = chebfun(NaN,[-1,x]);
        else
            y = chebfun(@(s) feval(u,s).*k(x,s),[-1 0],'exps',[0 0],'scale',u.scl,'maxdegree',128);

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

% integrand of the operator
    function y = j(x)
        if any(x == ends)
            y = chebfun(NaN,[0 x]);
        else
            y = chebfun(@(s) feval(u,s).*k(x,s),[0 x],'exps',[exps(1) alpha-1],'scale',u.scl);     
            
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

l = 0;
v1 = 1./gamma(alpha)*chebfun(@(x) sum(h0(x)), [l 1] ,'vectorize','exps',[.5 0],'maxdegree',32)
% w = v1+v3
w = 1./gamma(alpha)*chebfun(@(x) 0*sum(h0(x)) + sum(j(x)), [l 1] ,'vectorize','exps',[.5 0],'maxdegree',32)

chebpolyplot(v1)
xx = linspace(0,1,1000);

figure
plot(v,'b',w,'r',v1,'--k'); hold on
plot(w+v1,'--c');
error

end