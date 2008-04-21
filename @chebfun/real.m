function Fout = real(F)
% REAL	Complex real part
% REAL(F) is the real part of F.

%  Chebfun Version 2.0
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