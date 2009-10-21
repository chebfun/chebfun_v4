function out = sum(g)
% SUM	Definite integral from -1 to 1
% SUM(G) is the integral from -1 to 1 of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

% Linear map (simple variable substitution)
if strcmp(g.map.name,'linear')
    if ~any(g.exps)
        out = sum_unit_interval(g)*g.map.der(1);
    else
        exps = g.exps;
        [x w] = jacpts(ceil(g.n/2)+1,-exps(2),-exps(1));  % Huh!?
        g.exps = [0 0];
        out = w*bary(x,g.vals)*g.map.der(1).^(1-sum(exps));
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
        exps = g.exps;
        [x w] = jacpts(ceil(g.n/2)+1,-exps(2),-exps(1));  % Huh!?
        g.exps = [0 0];
        out = w*bary(x,g.vals,g.map.for(chebpts(g.n)))*g.map.der(1).^(1-sum(exps));
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