function rts = roots(f,varargin)
% ROOTS	  Roots of a chebfun.
% ROOTS(F) returns the roots of F in the interval where it is defined.
%
% ROOTS(F,'all') returns the roots of all the polynomials representing the
% smooth pieces of F.
%
% ROOTS(F,'norecurence') deactivates the recursion procedure used to
% compute roots (see the Guide 3: Rootfinding and minima and maxima for
% more information of this recursion procedure).
%
% ROOTS(F,'complex') returns the roots of all the polynomials representing
% the smooth pieces of F that are inside a chebfun ellipse. This capability
% may remove some spurious roots that can appear if using ROOTS(F,'all').
%
% ROOTS(F,'nopolish') deactivates the 'polishing' procedure of applying a 
% Newton step after solving the colleage matrix eigenvalue problem to
% obtain the roots. Since the Chebyshev coefficients of the function have
% already been computed, this comes at very little cost.
%
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

% Default preferences
rootspref = struct('all', 0, 'recurse', 1, 'prune', 0, 'polish', chebfunpref('polishroots'));
for k = 1:nargin-1
    argin = varargin{k};
    switch argin
        case 'all', 
            rootspref.all = 1;
            rootspref.prune = 0;
        case {'norecurse', 'norecurence'}
            rootspref.recurse = 0;
        case {'recurse', 'recurence'}
            rootspref.recurse = 1;
        case 'complex'
            rootspref.prune = 1;
            rootspref.all = 1;
        case 'polish'
            rootspref.polish = 1;
        case 'nopolish'
            rootspref.polish = 0;
        otherwise
            error('CHEBFUN:roots:UnknownOption','Unknown option.')
    end
end

ends = f.ends;
hs = hscale(f);
rts = []; % all roots will be stored here
for i = 1:f.nfuns
    a = ends(i); b = ends(i+1);
    lfun = f.funs(i);
    rs = roots(lfun,rootspref);
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
%             if ~(lfun.exps(2) < 0) && ~(rfun.exps(1) < 0)
                rts = [rts; b];
%             end
        end
%   if i < f.nfuns && ( isempty(rts) || abs(rts(end)-b) > 1e-14*hs )
%       rfun = f.funs(i+1);
%       fleft = feval(lfun,1); fright = feval(rfun,-1);
%       if real(fleft)*real(fright) <= 0 && imag(fleft)*imag(fright) <= 0
%           rts = [rts; b];
        end
    end    
end 
