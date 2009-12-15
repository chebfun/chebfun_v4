function Fout = real(F)
% REAL  Complex real part.
% REAL(F) is the real part of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = F;
for k = 1:numel(F)
    Fout(k) = realcol(F(k));
end
% ---------------------------

function fout = realcol(f)

fout = f;
for i = 1:f.nfuns
    fout.funs(i) = real(f.funs(i));
end
fout.imps = real(f.imps);