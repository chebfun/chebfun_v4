function X = vscale(f)
% VSCALE Find the vertical scale of chebfun F
%
% Pachon, Platte, Trefethen, 2007, Chebfun Version 2.0
X = 0;
nfuns = length(f.funs);
for i = 1:nfuns
    v = get(f.funs{i},'val');
    X = max(X,max(abs(v))); 
end
