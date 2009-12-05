function out = sum(g)
% SUM	Definite integral from -1 to 1
% SUM(G) is the integral from -1 to 1 of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

% Deal with divergent integrands
exps = g.exps;
ends = g.map.par(1:2);
if any(exps<=-1)
    sl = sign(g.vals(1));    sr = sign(g.vals(end));
    if all(exps <= -1)
        if  sl == sr
            out = sl.*inf;
        else
            out = NaN;
            return
        end
    elseif (exps(1) <= -1 && sl == -1) || (exps(2) <= -1 && sr == -1)
        out = -inf;
    else
        out = inf;
    end
    %      warning('CHEBFUN:sum:inf',['Integrand diverges to infinity on domain. ', ...
    %     'Assuming integral is infinite.']);
    return
end

% Linear map (simple variable substitution)
if strcmp(g.map.name,'linear')
    if ~any(g.exps)
        out = sum_unit_interval(g)*g.map.der(1);
    else
        [x w] = jacpts(ceil(g.n/2)+1,exps(2),exps(1));
        % (Our exps are the reverse of Jacobi polynomials,
        %   i.e. exps(1) = beta, exps(2) = alpha.)
        g.exps = [0 0];
        
        % Mutliply by (diff(ends)/2)^-sum(exps) to make h-scale invariant
        out = w*bary(x,g.vals)*g.map.der(1).^(1+sum(exps))*(diff(ends)/2)^-sum(exps);
        
    end
    
    % Unbounded domain map. This works somewhat as domain truncation.
    % For functions that decay slowly, this is inaccurate. Exponential decay
    % should work well.
elseif any(isinf(ends))
    
    % constant case
    if g.n == 1
        if abs(g.vals) <= chebfunpref('eps')*10*g.scl.v
            out = 0;
        else
            out = inf*sign(g.vals);
        end
        return
    end    
        
    vends = g.vals([1,end]);
    tol = max(10*chebfunpref('eps'),1e-8)*g.scl.v; % Loose tolerance
    
    % Linear case (must be like f=c*(1/x) and integral diverges)
    if g.n == 2
       if all(abs(g.vals) <= chebfunpref('eps')*10*g.scl.v)
            out = 0;
       elseif isinf(ends(1)) 
           if abs(g.vals(1)) < tol
                out = inf*sign(g.vals(2));
           else
                out = inf*sign(g.vals(1));
           end
       else
           if abs(g.vals(2)) < tol
                out = inf*sign(g.vals(1));
           else
                out = inf*sign(g.vals(2));
           end
       end
       return
    end
    
    % Check if not zero at infinity (unbounded integral, simple case)   
    unbounded = [];
    if isinf(ends(1))
        % integral is +-inf if endpoint value isn't zero
        if abs(g.vals(1)) > tol
            unbounded(1) = sign(vends(1))*inf;
        end
    end
    if isinf(ends(2))
        % integral is nan if endpoint value isn't zero
        if abs(g.vals(end)) > tol
            unbounded(2) = sign(vends(2))*inf;
        end
    end
    if ~isempty(unbounded)
        out = sum(unbounded);
        return
    end
    
    % Extract roots (type of trick)    
    % Besides having a zero at (+- 1), the fun should decrease towards the
    % endpoint. Decaying faster than 1/x^2 results in a double root. 
    % ---------------------------------------------------------------------
    y = chebpts(g.n, 2);
    pref = chebfunpref;
    pref.extrapolate = true;
    pref.eps = pref.eps*10;
    
    if isinf(ends(2))   
        gtmp = g; gtmp.vals = gtmp.vals./(1-y);
        gtmp = extrapolate(gtmp,pref,y);        
        if abs(gtmp.vals(end)) > tol && diff(gtmp.vals((end-1:end))./diff(y(end-1:end))) > -g.scl.v/g.scl.h
            unbounded(1) = inf*sign(g.vals(end-1));
        else
            g.vals(end) = 0;
        end
    end        
    if isinf(ends(1))
        gtmp = g; gtmp.vals = gtmp.vals./(1+y);
        gtmp = extrapolate(gtmp,pref,y);         
        if abs(gtmp.vals(1)) > tol && diff(gtmp.vals(1:2)./diff(y(1:2))) < g.scl.v/g.scl.h
           unbounded(2) = inf*sign(g.vals(2));
        else
            g.vals(1) = 0;
        end
    end
    if ~isempty(unbounded)
        out = sum(unbounded);
        return
    end
    % ---------------------------------------------------------------------
    
    % clean up rounding errors in exponential decay
    if isinf(ends(1)) && norm(g.vals(1:3),inf) < tol
         g.vals(abs(g.vals) < max(10*abs(vends(1)),10*eps*g.scl.v)) = 0;
    end
    if isinf(ends(2)) && norm(g.vals(end-2:end),inf) < tol
       g.vals(abs(g.vals) < max(10*abs(vends(2)),10*eps*g.scl.v)) = 0;
    end
        
    % Chain rule and extrapolate
    g.vals = g.vals.*g.map.der(y);
    g = extrapolate(g,pref,y);    
    out = sum_unit_interval(g);
    
% General map case
else
    if ~any(g.exps)
        map = g.map;
        g.map = linear([-1 1]);
        out = sum_unit_interval(g.*fun(map.der,[-1,1]));
    else
        disp('Warning sum is not properly for implemented for funs')
        disp('which have both nontrivial maps and exponents.')
        disp('It may be very slow!');
        %         warning('CHEBFUN:fun:sum:nonlinmap&exps',...
        %             ['Warning sum for funs with nontirivial maps and exponents is not properly ', ...
        %             'implemented and may be slow!']);
        pref = chebfunpref;
        pref.exps = {g.exps(1) g.exps(2)};
        g = fun(@(x) feval(g,x),linear(g.map.par(1:2)), pref, g.scl);
        out = sum(g);
    end
    
end

end

function out = sum_unit_interval(g)
% Integral in the unit interval
n = g.n;
if (n==1), out=g.vals*2; return; end
c = chebpoly(g);
c = flipud(c);
c(2:2:end) = 0;
out = (c.'*[2 0 2./(1-((2:n-1)).^2)].').';
end