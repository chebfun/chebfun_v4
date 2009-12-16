function Fout = cumsum(F)
% CUMSUM   Indefinite integral.
% CUMSUM(F) is the indefinite integral of the chebfun F. Dirac deltas 
% already existing in F will decrease their degree.
%
% CUMSUM does not currently support chebfuns whose indefinite integral diverges
% (i.e. has exponents <-1) when using nontrivial maps. Even for chebfuns
% with a bounded definite integral, nontrivial maps will be slow.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = F;
for k = 1:numel(F)
    Fout(k) = cumsumcol(F(k));
end

% -------------------------------------
function fout = cumsumcol(f)

if isempty(f), fout = chebfun; return, end

exps = get(f,'exps');
ends = f.ends;

for k = 1:size(exps,1)
    if all(exps(k,:)) && any(exps(k,:)<=-1)
        midpt = mean(ends(k:k+1));
        index = struct('type','()','subs',{{midpt}});
        f = subsasgn(f,index,feval(f,midpt));
    end
end

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
for i = 1:f.nfuns    
    vals(i) = get(funs(i),'lval');    
end
vals(f.nfuns+1) = get(funs(f.nfuns),'rval');

fout = set(f, 'funs', funs); 
fout.imps = [vals; f.imps(3:end,:)];

fout.jacobian = anon('@(u) cumsum(domain(f))*jacobian(f,u)',{'f'},{f});
fout.ID = newIDnum();