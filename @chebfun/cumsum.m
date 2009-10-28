function Fout = cumsum(F)
% CUMSUM   Indefinite integral.
% CUMSUM(F) is the indefinite integral of the chebfun F. Dirac deltas 
% already existing in F will decrease their degree.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

Fout = F;
for k = 1:numel(F)
    Fout(k) = cumsumcol(F(k));
end

% -------------------------------------
function fout = cumsumcol(f)

if isempty(f), fout = chebfun; return, end

if any(get(f,'exps')<=-1), error('CHEBFUN:cumsum:inf',...
        'Cumsum does not currently support functions which diverge to infinity'); end

ends = f.ends;

if size(f.imps,1)>1
    imps = f.imps(2,:);
else
    imps = zeros(size(ends));
end

Fb = imps(1);
funs = f.funs;
for i = 1:f.nfuns
    funs(i) = cumsum(funs(i)) + Fb;
    Fb = funs(i).vals(end) + imps(i+1);
end

vals = zeros(1,f.nfuns+1);
for i = 2:f.nfuns
    vals(i) = funs(i).vals(1)./diff(ends(k:k+1)).^funs(k).exps(2);
end
vals(f.nfuns+1) = funs(f.nfuns).vals(end).*diff(ends(end-1:end)).^funs(end).exps(1);

fout = set(f, 'funs', funs); 
fout.imps = [vals; f.imps(3:end,:)];