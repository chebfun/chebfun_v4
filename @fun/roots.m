function out = roots(g,all,recurse,prune)
% ROOTS	Roots in the interval [-1,1]
% ROOTS(G) returns the roots of the FUN G in the interval [-1,1].
% ROOTS(G,'all') returns all the roots.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

if nargin == 1
    all = 0;
    recurse = 1;
    prune = 0;
end
r = rootsunit(g,all,recurse,prune);
if prune & ~recurse
    rho = sqrt(eps)^(-1/g.n);
    rho_roots = abs(r+sqrt(r.^2-1));
    rho_roots(rho_roots<1) = 1./rho_roots(rho_roots<1);
    out = r(rho_roots<=rho);
else
    out = r;
end
out = g.map.for(out);

function out = rootsunit(g,all,recurse,prune)
% Computes the roots on the unit interval

% Assume that the map in g is the identity: compute the roots in the
% interval [-1 1]!
ends = g.map.par(1:2);
g.map.for = @(y) y; 
g.map.inv = @(x) x; 
g.map.par(1:2) = [-1 1]; 
g.map.name ='linear';

% Update horizontal scale accordingly
if norm(ends,inf) < inf;
    g.scl.h = g.scl.h*2/diff(ends);
end

tol = 100*eps;
    
if ~recurse || (g.n<101)                                    % for small length funs
    c=chebpoly(g);                              % compute Cheb coeffs
    if abs(c(1)) < 1e-14*norm(c,inf)
        ind= find(abs(c)>1e-14*norm(c,inf),1,'first');
        if isempty(ind), out = zeros(length(c),1);
            return
        end
        c=c(ind:end);
        g.vals = chebpolyval(c);
        g.n = length(c);
    end
    if (g.n<=4)
        r=roots(poly(g));
    else
        c=.5*c(end:-1:2)/(-c(1));               % assemble colleague matrix A
        c(end-1)=c(end-1)+.5;
        oh=.5*ones(length(c)-1,1);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Replace this with A(end:-1:1,end:-1:1)' (LNT's trick)
       % to fix a bug in roots, e.g. p = fun( '(x-.1).*(x+.9).*x.*(x-.9) + 1e-15*x.^5' );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Original colleague matrix:
%        A=diag(oh,1)+diag(oh,-1);
%        A(1,2)=1;
%        A(end,:)=c;

        % Modified colleague matrix:
        A = diag(oh,1)+diag(oh,-1);
        A(end-1,end) = 1;
        A(:,1) = flipud(c);
        
        r=eig(A);                               % compute roots as eig(A)
        
    end
    if ~all
        mask=abs(imag(r))<tol*g.scl.h;           % filter imaginary roots
        r = real( r(mask) );
        out = sort(r(abs(r) <= 1+tol*g.scl.h));  % keep roots inside [-1 1]   
        if ~isempty(out)
            out(1) = max(out(1),-1);                % correct root -1
            out(end) = min(out(end),1);             % correct root  1
        end
    elseif prune
        rho = sqrt(eps)^(-1/g.n);
        rho_roots = abs(r+sqrt(r.^2-1));
        rho_roots(rho_roots<1) = 1./rho_roots(rho_roots<1);
        out = r(rho_roots<=rho);
    else
        out = r;
    end
else
    
    c = -0.004849834917525; % arbitrary splitting point to avoid a root at c
    g1 = restrict(g,[-1 c]);
    g2 = restrict(g,[c,1]);
    out = [-1+(rootsunit(g1,all,recurse,prune)+1)*.5*(1+c);...        % find roots recursively 
        c+(rootsunit(g2,all,recurse,prune)+1)*.5*(1-c)];              % and rescale them
end
