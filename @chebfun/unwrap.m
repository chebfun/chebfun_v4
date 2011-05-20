function p = unwrap(p,varargin)
%UNWRAP Unwrap chebfun phase angle.
%   UNWRAP(P) unwraps radian phases P by changing absolute jumps greater
%   than or equal to pi to their 2*pi complement. It unwraps along the
%   continuous dimension of P and leaves the first fun along this dimension
%   unchanged.
%
%   UNWRAP(P,TOL) uses a jump tolerance of TOL rather than the default 
%   TOL = pi.
%
%   See also ANGLE, ABS.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if numel(varargin) > 2 
    dim = varargin{2};
    if (dim == 1 && ~p(1).trans) || (dim == 2 && p(1).trans)
        warning('CHEBFUN:unwrap:dim',['Unwrap only operates along the ',...
            'continuous dimension of a quasimatrix.']);
    end
    varargin(2) = [];
end

% Loop over the columns
for k = 1:numel(p);
    p(k) = colfun(p(k),varargin{:});
end


function p = colfun(p,varargin)

% Trivial case
if p.nfuns == 1, return, end

% Store data about the imps for later
tol = 1e-14*p.scl;
idxl = abs(p.imps(1,:) - feval(p,p.ends,'left')) < tol;
idxr = abs(p.imps(1,:) - feval(p,p.ends,'right')) < tol;

% Simply call built-in unwrap on the values
v = get(p,'vals');
w = unwrap(v,varargin{:});

% Get the indices of the break points
n = zeros(p.nfuns,1);
for k = 1:p.nfuns, n(k) = p.funs(k).n; end
csn = [0 ; cumsum(n)];

% Update to the new values
for k = 1:p.nfuns
    p.funs(k).vals = w(csn(k)+(1:n(k)));
end

% Update the imps
p.imps(1,idxl) = feval(p,p.ends(idxl),'left');
p.imps(1,idxr) = feval(p,p.ends(idxr),'right');

% Merge to tidy up unneeded breakpoints
pref = chebfunpref;
pref.extrapolate = 1;
p = merge(p,pref);