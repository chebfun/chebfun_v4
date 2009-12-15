function rts = roots(f,varargin)
% ROOTS	  Roots of a chebfun.
% ROOTS(F) returns the roots of F in the interval where it is defined.
% ROOTS(F,'all') returns the roots of all the polynomials representing the
% smooth pieces of F.
% ROOTS(F,'norecurence') deactivates the recursion procedure used to
% compute roots (see the Guide 3: Rootfinding and minima and maxima for
% more information of this recursion procedure).
% ROOTS(F,'complex') returns the roots of all the polynomials representing
% the smooth pieces of F that are inside a chebfun ellipse. This capability
% may remove some spurious roots that can appear if using ROOTS(F,'all').
% ROOTS(F,'all','norecurence') and ROOTS(F,'complex','norecurence')
% deactivates the recursion procedure to compute the roots as explained in
% the 'all' and 'complex' modes.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:
 

tol = 1e-14;

if numel(f)>1
    error('CHEBFUN:roots:quasi','roots does not work with chebfun quasi-matrices')
end
all = 0; recurse = 1; prune = 0;
for k = 1:nargin-1
    argin = varargin{k};
    if strcmp(argin,'all'), 
        all = 1;
        prune = 0;
    elseif strcmp (argin,'norecurse'),
        recurse = 0;
    elseif strcmp (argin,'recurse'),
        recurse = 1;
    elseif strcmp (argin,'complex'),
        prune = 1;
        all = 1;
    else
        error('CHEBFUN:roots:UnknownOption','Unknown option.')
    end
end



ends = f.ends;
hs = hscale(f);
rts = []; % all roots will be stored here
for i = 1:f.nfuns
    a = ends(i); b = ends(i+1);
    lfun = f.funs(i);
    rs = roots(lfun,all,recurse,prune);
    if ~isempty(rs)
        if ~isempty(rts)
            while length(rs)>=1 && abs(rts(end)-rs(1))<tol*hs
            rs=rs(2:end);
        end
        end
        rts = [rts; rs];
    end
    if isreal(f) && i<f.nfuns && (isempty(rts) || abs(rts(end)-b)>tol*hs )
        rfun = f.funs(i+1);
        if lfun.vals(end)*rfun.vals(1) <= 0, 
            rts = [rts; b];
        end
%   if i < f.nfuns && ( isempty(rts) || abs(rts(end)-b) > 1e-14*hs )
%       rfun = f.funs(i+1);
%       fleft = feval(lfun,1); fright = feval(rfun,-1);
%       if real(fleft)*real(fright) <= 0 && imag(fleft)*imag(fright) <= 0
%           rts = [rts; b];
        end
    end    
end 
