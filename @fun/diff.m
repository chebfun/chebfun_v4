function g = diff(g,k)
% DIFF	Differentiation
% DIFF(G) is the derivative of the fun G.  
%
% DIFF(G,K) is the K-th derivative of G.
% If the fun G of length n is represented as
%
%       SUM_{r=0}^{n-1} C_r T_r(x)
%
% its derivative is represented with a fun of length n-1 given by
%
%       SUM_{r=0}^{n-2} c_r T_r (x)
% 
% where c_0 is determined by
% 
%       c_0 = c_2/2 + C_1;
%
% and for r > 0,
%
%       c_r = c_{r+2} + 2*(r+1)*C_{r+1}, 
%
% with c_{n} = c_{n+1} = 0.
%
% See "Chebyshev Polynomials" by Mason ad Handscomb, CRC 2002, pg 34.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if isempty(g), return, end
if (nargin==1), k=1; end                
c = chebpoly(g);                        % obtain Cheb coeffs {C_r}
n = g.n;

% Separate in 3 cases:
% 1 Linear map!
if strcmp(g.map.name,'linear')
    
    for i = 1:k                             % loop for higher derivatives
        if n == 1, 
            g = set(g,'vals',0); g.scl.v = 0;
            return 
        end % derivative of constant is zero
        c = newcoeffs_der(c);
        n = n-1;
    end
    g = fun(chebpolyval(c)/g.map.der(1).^k, g.map.par(1:2));
    
% Unbounded map    
elseif norm(g.map.par(1:2),inf) == inf
    nz = 2; % number of zeros needed to augment coefficients due chain rule
    infboth = false;
    if isinf(g.map.par(1)) && isinf(g.map.par(2))
        nz = 45;
        infboth = true;
    end
    for i = 1:k                             % loop for higher derivatives
        if n == 1, 
            g = set(g,'vals',0); g.scl.v = 0;
            return 
        end                                 % derivative of constant is zero
        % increase length because because degree increases with
        % derivatives (by 1);
        cout = newcoeffs_der([zeros(nz,1); c]);
        vals = chebpolyval(cout)./g.map.der(chebpts(n+nz-1));
        g.vals = vals;
        g.n = length(vals);
        if i ~= k
            c = chebpoly(g);
            n = g.n;
        end
    end 
    g.scl.v = max(g.scl.v,norm(vals,inf));
    if infboth
        g = simplify(g);
    end
    
% General (MAP) case: (slow !!!)
else
    for i = 1:k                             % loop for higher derivatives
        if n == 1, 
            g = set(g,'vals',0); g.scl.v = 0;
            return 
        end                                 % derivative of constant is zero
        cout = newcoeffs_der(c);
        vals = chebpolyval(cout);
        g.vals = vals; g.scl.v = max(g.scl.v,norm(vals,inf));
        g.n = length(vals);
        map = g.map;
        g.map = linear;
        g = fun(@(x) feval(g,x)./map.der(x),[-1 1]); % construct fun from {c_r}
        g.map = map;
        if i ~= k
            c = chebpoly(g);
            n = length(c);
        end
    end
end


function cout = newcoeffs_der(c)
% C is the coefficients of a chebyshev polynomials (on [-1,1])
% COUT are the coefficiets of its derivative

n = length(c);
cout = zeros(n+1,1);                % initialize vector {c_r}
v = [0; 0; 2*(n-1:-1:1)'.*c(1:end-1)]; % temporal vector
cout(1:2:end) = cumsum(v(1:2:end)); % compute c_{n-2}, c_{n-4},...
cout(2:2:end) = cumsum(v(2:2:end)); % compute c_{n-3}, c_{n-5},...
cout(end) = .5*cout(end);           % rectify the value for c_0
cout = cout(3:end);
