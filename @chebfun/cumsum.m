function F = cumsum(f)
% CUMSUM	Indefinite integral
% CUMSUM(F) is the indefinite integral of the chebfun F. Dirac deltas 
% already existing in F will decrease their degree.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
nfuns = length(f.funs);
ends = f.ends;
F = chebfun;
F.ends = ends;
Fb = f.imps(1,1);
for i = 1:nfuns
    a = ends(i); b = ends(i+1);
    F.funs{i} = ((b-a)/2)*cumsum(f.funs{i}) + Fb;
    Fb = F.funs{i}(1)+f.imps(1,i+1);
end
F.imps = f.imps(2:end,:);
if isempty(F.imps)
    F.imps = zeros(size(F.ends));
end