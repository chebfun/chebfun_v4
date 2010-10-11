function out = roots(g,varargin)
% ROOTS	Roots in the interval [-1,1]
% ROOTS(G) returns the roots of the FUN G in the interval [-1,1].
% ROOTS(G,'all') returns all the roots.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

% Default preferences
rootspref = struct('all', 0, 'recurse', 1, 'prune', 0, 'polish', chebfunpref('polishroots'));

if nargin == 2
    if isstruct(varargin{1})
        rootspref = varargin{1};
    else
        rootspref.all = true;
    end
elseif nargin > 2
    rootspref.all = varargin{1};
    rootspref.recurse = varargin{2};
end
if nargin > 3
    rootspref.prune = varargin{3};
end

r = rootsunit(g,rootspref);
if rootspref.prune && ~rootspref.recurse
    rho = sqrt(eps)^(-1/g.n);
    rho_roots = abs(r+sqrt(r.^2-1));
    rho_roots(rho_roots<1) = 1./rho_roots(rho_roots<1);
    out = r(rho_roots<=rho);
else
    out = r;
end
out = g.map.for(out);

function out = rootsunit(g,rootspref)
% Computes the roots on the unit interval

all = rootspref.all;
recurse = rootspref.recurse;
prune = rootspref.prune;
polish = rootspref.polish;

% Assume that the map in g is the identity: compute the roots in the
% interval [-1 1]!
ends = g.map.par(1:2);
g.map = linear([-1 1]);

% Update horizontal scale accordingly
if norm(ends,inf) < inf;
    g.scl.h = g.scl.h*2/diff(ends);
end

tol = 100*eps;
    
if ~recurse || (g.n<101)                                    % for small length funs
    coeffs = chebpoly(g);                              % compute Cheb coeffs
    c = coeffs;
    if abs(c(1)) < 1e-14*norm(c,inf) || c(1) == 0
        ind = find(abs(c)>1e-14*norm(c,inf),1,'first');
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
        out = sort(r(abs(r) <= 1+2*tol*g.scl.h));  % keep roots inside [-1 1]   
        % polish
        if polish
            gout = feval(g,out);
            step = gout./feval(diff(g,1,coeffs),out);
            step(isnan(step) | isinf(step)) = 0;
%             outnew = out - step;
%             mask = abs(gout) > abs(feval(g,outnew));
%             out(mask) = outnew(mask);
            out = out-step;
        end
        
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
    out = [-1+(rootsunit(g1,rootspref)+1)*.5*(1+c);...        % find roots recursively 
        c+(rootsunit(g2,rootspref)+1)*.5*(1-c)];              % and rescale them
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
