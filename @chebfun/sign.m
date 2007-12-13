function F = sign(f)
% SIGN  Sign function.
% G = SIGN(F) returns a piecewise constant chebfun G such that G(x) = 1 in
% the interval where F(x)>0, G(x) = -1 in the interval where F(x)<0 and
% G(x) = 0  in the interval where F(x) = 0. The breakpoints of H are
% introduced at zeros of F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

% NOTE: sign(chebfun(0,'x',[-1 0 1])) won't work properly.
% NOTE: this does not work if f is complex
r = roots(f);
ends = f.ends;
hs = hscale(f);
if isempty(r), 
    F = chebfun(sign(f.funs{1}),domain(f));
    return;
else
    if abs(r(1)  - ends(1)  ) > 1e-14*hs, r = [ends(1); r  ]; end
    if abs(r(end)- ends(end)) > 1e-14*hs, r = [r; ends(end)]; end
end
nr = length(r);
newints = zeros(1,nr);
newints(1) = ends(1);
ff = cell(nr-1,1);
for i = 1:nr-1
    a = r(i); b = r(i+1);
    midpnt = (a+b)/2;
    S.type = '()';
    S.subs = {midpnt};
    ff{i} = sign(subsref(f,S));
    newints(i+1) = b;
end
% Improvement: equal constants in contiguous intervals should be collapsed.
F = chebfun(ff,newints);
