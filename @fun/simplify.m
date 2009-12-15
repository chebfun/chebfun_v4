function g = simplify(g,tol,kind)
% This function removes leading Chebyshev coefficients that are below 
% epsilon, relative to the verical scale stored in g.scl.v
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

% This is the code in the old fixedgrow.m by LNT
gn = g.n;
if gn < 2  % cant be simpler than a constant!
    return; 
end

if nargin == 1
    tol = chebfunpref('eps');
end
if nargin < 3
    kind = 2; % Second kind is default
end
epstol = 2^-52;

if g.scl.v == 0, 
    % Check for NaN's or Inf's
    if any(isnan(g.vals)) || isinf(g.scl.v)
        error('FUN:simplify:naneval','Function returned NaN or Inf when evaluated.')
    end
    g = set(g,'vals',0);               % is g the zero function?
    return;
    elseif isinf(g.scl.v)
%         error('FUN:simplify:InfEval', ...
%                 'Function returned Inf when evaluated.')

%     inf located, try markfun!
    return
end
c = chebpoly(g,kind);                      % coeffs of Cheb expansion of g
ac = abs(c)/g.scl.v;                  % abs value relative to scale of f
Tlen = min(g.n,max(4,round((gn-1)/8)));% length of tail to test
% which basically is the same as:
% Tlen = n,             for n = 1:3
% Tlen = 3,             for n = 4:25
% Tlen = round((n-1)/8) for n > 25

% LNT's choice --------------------------------------
%Tmax = 2e-16*Tlen^(2/3);             % maximum permitted size of tail
% RodP's choice -------------------------------------
xpts = g.map.for(chebpts(gn,kind));
df = max(diff(xpts),eps*g.scl.h);
mdiff =  (g.scl.h/g.scl.v)*norm(diff(g.vals)./df,inf);
% Choose maximum between prescribed tolerance and estimated rounding errors
Tmax = max(tol,epstol*min(1e12,max(mdiff,Tlen^(2/3))));
% ---------------------------------------------------
if max(ac(1:Tlen)) < Tmax             % we have converged; now chop tail
    Tend = find(ac>=Tmax,1,'first');  % pos of last entry below Tmax
    if isempty(Tend)                  % is g the zero function?  
        if any(isnan(ac))
            error('FUN:simplify:NaNEval', ...
                'Function returned NaN when evaluated.')
        else
            g = set(g,'vals',0);
            return;
        end
    end
    Tend=Tend-1;
    ac = ac(1:Tend); ac(1) = .225*tol;  % was originally hardwired at 5e-17;   
    for i = 2:Tend                    % compute the cumulative max of
        ac(i) = max(ac(i),ac(i-1));   %   the tail entries and 5e-17
    end
    Tbpb = log(1000*Tmax./ac)./ ...
        (length(c)-(1:Tend)');         % bang/buck of chopping at each pos
    [foo,Tchop] = max(Tbpb(3:Tend));  % Tchop = pos at which to chop
    v = chebpolyval(c(Tchop+3:end),2);  % chop the tail 
                                        % store values at 2nd kind points
   % if mod(length(v),2) == 1
   %     v = chebpolyval(c(Tchop+2:end));  % chop the tail
   % end
    if length(v) > 1 && kind == 2
        % forces interpolation at endpoints
        g.vals = [g.vals(1);v(2:end-1);g.vals(end)];              
    else
        g.vals = v;
    end
    g.n = length(v);
end
