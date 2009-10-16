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
ends = g.map.par(1:2);

%     for i = 1:k                             % loop for higher derivatives
%         if n == 1,
%             g = set(g,'vals',0); g.scl.v = 0;
%             return
%         end                                 % derivative of constant is zero
%         cout = newcoeffs_der(c);
%         vals = chebpolyval(cout);
%         g.vals = vals; g.scl.v = max(g.scl.v,norm(vals,inf));
%         g.n = length(vals);
%         map = g.map;
%         g.map = linear([-1,1]);
%         g = fun(@(x) feval(g,x)./map.der(x),[-1 1]); % construct fun from {c_r}
%         g.map = map;
%         if i ~= k
%             c = chebpoly(g);
%             n = length(c);
%         end
%     end


% Separate in 3 cases:
% 1 Linear map!
if strcmp(g.map.name,'linear')
    
    if ~any(g.exps) % simple case, no map or exponents
        for i = 1:k                             % loop for higher derivatives
            if n == 1,
                g = set(g,'vals',0); g.scl.v = 0;
                return
            end % derivative of constant is zero
            c = newcoeffs_der(c);
            n = n-1;
        end
        g = fun(chebpolyval(c)/g.map.der(1).^k, g.map.par(1:2));
        
    else % function which blows up, need chain rule

        for i = 1:k % loop for higher derivatives
            % Perhaps treat 2nd derivatives as a special case?
            if n == 1,
                c = 0;
            else
                c = newcoeffs_der(c);
            end
            
            exps = g.exps;

            if exps(1) && ~exps(2)
                g = fun([0 diff(ends)],ends).*fun(chebpolyval(c)/g.map.der(1), ends) - g.exps(1).*g;
                exps(1) = exps(1) + 1;
            end
            
            if ~exps(1) && exps(2)
                g = fun([diff(ends) 0],ends).*fun(chebpolyval(c)/g.map.der(1), ends) + g.exps(2).*g;
                exps(2) = exps(2) + 1;
            end
            
            if all(exps)               
                g = fun([0 -prod(ends) 0],ends).*fun(chebpolyval(c)/g.map.der(1), ends) + ...
                    (g.exps(2)*fun([0 diff(ends)],ends) - g.exps(1)*fun([diff(ends) 0],ends)).*g;
                exps = exps + 1;
            end
            
            g.exps = exps;
            
            if i~=k, 
                c = chebpoly(g);
                n = length(c);
            end
            
        end

    end
    % Unbounded map
elseif norm(g.map.par(1:2),inf) == inf
    
    if ~any(g.exps) error('chebfun:fun:diff','Cannot diff mapped funs with exps yet'); end
    
    nz = 2; % number of zeros needed to augment coefficients due chain rule
    infboth = false;
    if isinf(g.map.par(1)) && isinf(g.map.par(2))
        nz = 45;            % 1/derivative of this map requires length 45 to represent
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
    
    if ~any(g.exps) % old case with no exponents
    
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
            g.map = linear([-1,1]);
            g = fun(@(x) feval(g,x)./map.der(x),[-1 1]); % construct fun from {c_r}
            g.map = map;
            if i ~= k
                c = chebpoly(g);
                n = length(c);
            end
        end
        
    else
        
        for i = 1:k                  % loop for higher derivatives
            if n == 1,
                c = 0;               % derivative of constant is zero
            else
                c = newcoeffs_der(c);
            end                        
            vals = chebpolyval(c);
            
            exps = g.exps;
            g.exps = [0 0];
            map = g.map;
            
            if exps(1) && ~exps(2)
                gp = @(x) (map.for(x)-ends(1)).*bary(x,vals)./map.der(x);
                gp = fun(gp,[-1 1]);
                gp.map = map;
                g = gp - exps(1).*g;
                exps(1) = exps(1) + 1;
            end
            
            if ~exps(1) && exps(2)
                gp = @(x) (ends(2)-map.for(x)).*bary(x,vals)./map.der(x);
                gp = fun(gp,[-1 1]);
                gp.map = map;
                g = gp + exps(2).*g;
                exps(2) = exps(2) + 1;
            end

            if all(exps)      
                gp = @(x) (map.for(x)-ends(1)).*(ends(2)-map.for(x)).*bary(x,vals)./map.der(x);
                gp = fun(gp,[-1 1]);
                gp.map = map;
                g = gp + (exps(2)*fun(@(x) x-ends(1),map) - exps(1)*fun(@(x) ends(2)-x,map)).*g;
                exps = exps + 1;
            end
            
            g.exps = exps;
            
            if i ~= k
                c = chebpoly(g);
                n = length(c);
            end
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
