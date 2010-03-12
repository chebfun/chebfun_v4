function H = hermpoly(n,normalize)
% HERMPOLY   Laguerre polynomial of degree n.
% H = HERMPOLY(N) returns the chebfun corresponding to the monomial Hermite 
% polynomials H_N(x) on [-inf,inf], where N may be a vector of positive integers.
%
% H = HERMPOLY(N,'PHYS') normalises instead so that the coefficient of the
% x^N in H_N is 2^N.
%
% See also chebpoly, legpoly, jacpoly, and lagpoly.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if nargin == 1
    % by default we take the probabalist's definition
    normalize = 'prob';
end

if strcmpi(normalize,'phys') || strcmpi(normalize,'physics') || strcmpi(normalize,'physicist')
    normtype = 2;
else
    normtype = 1;
end

H = chebfun(@(x) 1,[-inf inf],'exps',[0 0],1);
if normtype == 1
    H(:,2) = chebfun(@(x) x,[-inf inf],'exps',[1 1]);
    for k = 2:max(n) % Recurrence relation
       H(:,k+1) = chebfun(@(x) (x.*feval(H(:,k),x)-(k-1)*feval(H(:,k-1),x)),[-inf inf],'exps',[k k],2*(k+1));
    end
else
    H(:,2) = chebfun(@(x) 2*x,[-inf inf],'exps',[1 1]);
    for k = 2:max(n) % Recurrence relation
       H(:,k+1) = chebfun(@(x) (2*x.*feval(H(:,k),x)-2*(k-1)*feval(H(:,k-1),x)),[-inf inf],'exps',[k k],2*(k+1));
    end
end

% Take only the ones we want
H = H(:,n+1);


