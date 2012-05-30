function d = dirac(f)
% DIRAC delta function
%
% D = DIRAC(F) returns a chebfun D which is zero on the domain of the
% chebfun F except at the simple roots of F, where it is infinite. This
% infinity may be examined by looking at the second row of the matrix
% D.IMPS

% DIRAC(F) is not defined if F has a zero of order greater than one within
% the domain of F.

% If F has break-points, they should not coinicde with the roots of F.
% However, F can have simple roots at either end points of its domain.

% See also chebfun/heaviside

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

tol = chebfunpref('eps');

[a b] = domain(f);

% extract the 'normal' roots of f
r = roots(f,'nojump','nozerofun');

% assume no roots at end points
rootA = 0;
rootB = 0;

% check for roots at the end points manually
if abs(feval(f,a)) < 100*tol*f.scl, rootA = 1; end
if abs(feval(f,b)) < 100*tol*f.scl, rootB = 1; end


% if there is no root of F within the domain or at the
% end points, return the zero chebfun
if isempty( r ) && ~rootA && ~rootB
    d = chebfun(0,f.ends);
    d.imps(2,:) = zeros(1,length(f.ends));
    return
end

% check if a root coincides with an interior break-point.
[rr ee] = meshgrid( f.ends(2:end-1), r );
if( any(abs(rr-ee) < 100*tol*f.scl) )
     error('CHEBFUN:dirac', 'Function has a root at a break-point');
end

ends = union(r,[a b]);
% if there is a root close to any of the end points, merge it
% with the respective end point.
if abs(ends(2)-ends(1)) < 100*tol*f.scl, ends(2) = []; end
if abs(ends(end)-ends(end-1)) < 100*tol*f.scl, ends(end-1) = []; end

% initialize a zero chebfun
d = chebfun(0,ends);

% check if any of the roots is not simple by
% looking at the derivative of F
df = diff(f);
dfends = feval(df,ends);
 
% check root order for interior break-points
if any(abs(dfends(2:end-1)) < 100*tol*df.scl)
    error('CHEBFUN:dirac', 'Function has a root which is not simple');
else
    % place delta functions with appropriate scaling at interior roots.
    d.imps(2,2:end-1) = 1./abs(dfends(2:end-1));
end

% check root order at the end points
if rootA
    % if root is not simple
    if abs(dfends(1)) < 100*tol*df.scl
        error('CHEBFUN:dirac', ...
        'Function has a root which is not simple at the left-end point');
    else
        % if root is simple, place a scaled delta-function
        % at the left-end point
        d.imps(2,1) = 1./abs(dfends(1));    
    end
end

if rootB
    % if root is not simple
    if abs(dfends(end)) < 100*tol*df.scl
    error('CHEBFUN:dirac', ...
    'Function has a root which is not simple at the right-end point');
    else
        % if root is simple, place a scaled delta-function
        % at the right-end point
        d.imps(2,end) = 1./abs(dfends(end));
    end
        
end