function g = cumsum(g)
% CUMSUM	Indefinite integral
% CUMSUM(G) is the indefinite integral of the fun G.
% If the fun G of length n is represented as
%
%       SUM_{r=0}^{n-1} c_r T_r(x)
%
% its integral is represented with a fun of length n+1 given by
%
%       SUM_{r=0}^{n} C_r T_r (x)
% 
% where C_0 is determined from the constant of integration as
% 
%       C_0 = SUM_{r=1}^{n} (-1)^(r+1) C_r;
%
% C_1 = c_0 - c_2/2, and for r > 0,
%
%       C_r = (c_{r-1} - c_{r+1})/(2r),
%
% with c_{n+1} = c_{n+2} = 0.
%
% See "Chebyshev Polynomials" by Mason and Handscomb, CRC 2002, pg 32-33.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

% linear map (simplest case)
if strcmp(g.map.name,'linear')
    
    if isempty(g), return, end
    g.vals = g.vals*g.map.der(0); % From change of variables to [-1,1]
    g = cumsum_unit_interval(g);
    
% Infinite intervals    
elseif norm(g.map.par(1:2),inf) == inf
    
    % constant case
    if g.n == 1
        if abs(g.vals) <= chebfunpref('eps')*10*g.scl.v
            g.vals = 0; g.n = 1; g.scl.v = 0;
        else
            warning('fun:cumsum','Integral seems to diverge')
            g.vals = nan; g.n = 1; g.scl.v = inf;
        end
        return
    end

    % non-constant case
    g = cumsum_unit_interval(changevar(g));
    
% General map case    
else
    
    map = g.map; g.map = linear([-1 1]);
    g = cumsum_unit_interval(g.*fun(map.der,g.map));
    g.map = map;
   
end

end

function g = cumsum_unit_interval(g)

    n = g.n;
    c = [0;0;chebpoly(g)];                        % obtain Cheb coeffs {c_r}
    cout = zeros(n-1,1);                          % initialize vector {C_r}
    cout(1:n-1) = (c(3:end-1)-c(1:end-3))./...    % compute C_(n+1) ... C_2
        (2*(n:-1:2)');
    cout(n,1) = c(end) - c(end-2)/2;              % compute C_1
    cout(n+1,1) = (-1).^(n+1:-1:2)*cout;          % compute C_0
    g.vals = chebpolyval(cout);
    g.scl.v = max(g.scl.v, norm(g.vals,inf));
    g.n = n+1;
    
end
