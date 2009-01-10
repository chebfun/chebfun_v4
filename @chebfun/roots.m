function rts = roots(f)
% ROOTS	  Roots of a chebfun.
% ROOTS(F) returns the roots of F in the interval where it is defined.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

tol = 1e-14;

if numel(f)>1
    error('roots does not work with chebfun quasi-matrices')
end

ends = f.ends;
hs = max(abs([ends(1), ends(2)]));
rts = []; % all roots will be stored here
for i = 1:f.nfuns
    a = ends(i); b = ends(i+1);
    lfun = f.funs(i);
    r = roots(lfun);
    if ~isempty(r)
        rs = scale(r,a,b); % roots in a piece
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
