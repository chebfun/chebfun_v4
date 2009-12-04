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
        out = w*bary(x,g.vals)*g.map.der(1).^(1+sum(exps))*(diff(g.map.par(1:2))/2)^-sum(exps);
        
    end

% Unbounded domain map. This works somewhat as domain truncation.
% For functions that decay slowly, this is inaccurate. Exponential decay
% should work well.
elseif any(isinf(g.map.par(1:2)))
    
    % constant case
    if g.n == 1
        if abs(g.vals) <= chebfunpref('eps')*10*g.scl.v
            out = 0;
        else
            out = inf*sign(g.vals);
        end
        return
    end

    % non-constant case

    % Check if the function decays fast enough
%    gm = g;
%    gm.map = linear([-1,1]);
%    dgm = diff(gm);
%    diverge = false;
%     % is the derivative zero at the inf?
%     if isinf(g.map.par(2)) && abs(dgm.vals(end)) > 1e-8*gm.scl.v
%         diverge = true;
%     end
%     % is the derivative zero at the -inf?
%     if isinf(g.map.par(1)) && abs(dgm.vals(1)) > 1e-8*gm.scl.v
%         diverge = true;
%     end
    
%    if diverge
%        out = nan;
%    else
     out = sum_unit_interval(changevar(g)); 
%    end
  
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
        pref.exps = {g.exps};
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