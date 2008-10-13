function gout = simplify(g)
% This function removes leading Chebyshev coefficients that are below 
% epsilon, relative to the verical scale stored in g.scl.v

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

% This is the code in the old fixedgrow.m by LNT
gout = g;
if g.scl.v == 0, 
    gout = set(g,'vals',0);               % is g the zero function?
    return;
    elseif isinf(g.scl.v)
        error('CHEBFUN:simplify:InfEval', ...
                'Function returned Inf when evaluated.')
end

c = chebpoly(g);                      % coeffs of Cheb expansion of g
ac = abs(c)/g.scl.v;                  % abs value relative to scale of f
Tlen = min(g.n,max(3,round((g.n-1)/8)));% length of tail to test
% which basically is the same as:
% Tlen = n,             for n = 1:3
% Tlen = 3,             for n = 4:25
% Tlen = round((n-1)/8) for n > 25

% LNT's choice --------------------------------------
%Tmax = 2e-16*Tlen^(2/3);             % maximum permitted size of tail
% RodP's choice -------------------------------------
mdiff =  (g.scl.h/g.scl.v)*norm(diff(g.vals)./diff(chebpts(g.n)),inf);
Tmax = 2^-52*min(1e10,max(mdiff,Tlen^(2/3)));
% ---------------------------------------------------
if max(ac(1:Tlen)) < Tmax             % we have converged; now chop tail
    Tend = find(ac>=Tmax,1,'first');  % pos of last entry below Tmax
    if isempty(Tend)                  % is g the zero function?  
        if any(isnan(ac))
            error('CHEBFUN:simplify:NaNEval', ...
                'Function returned NaN when evaluated.')
        else
            gout = set(g,'vals',0);
            return;
        end
    end
    Tend=Tend-1;
    ac = ac(1:Tend); ac(1) = 5e-17;   
    for i = 2:Tend                    % compute the cumulative max of
        ac(i) = max(ac(i),ac(i-1));   %   the tail entries and 5e-17
    end
    Tbpb = log(1000*Tmax./ac)./ ...
        (length(c)-(1:Tend)');         % bang/buck of chopping at each pos
    [foo,Tchop] = max(Tbpb(3:Tend));  % Tchop = pos at which to chop
    v = chebpolyval(c(Tchop+3:end));  % chop the tail
    gout = set(g,'vals',v);
end