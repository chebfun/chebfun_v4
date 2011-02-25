function Fout = sign(F)
% SIGN   Sign function.
% G = SIGN(F) returns a piecewise constant chebfun G such that G(x) = 1 in
% the interval where F(x)>0, G(x) = -1 in the interval where F(x)<0 and
% G(x) = 0  in the interval where F(x) = 0. The breakpoints of H are
% introduced at zeros of F.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

Fout = F;
for k = 1:numel(F)
    Fout(k) = signcol(F(k));
end

% ----------------------------------
function fout = signcol(f)

if isempty(f), fout = chebfun; return, end

% If f is not real, sign returns f.
if ~isreal(get(f,'vals'))
    fout = f; return
end

r = roots(f);
ends = f.ends;
hs = hscale(f);
    
if isempty(r), 
    fout = chebfun(sign(f.funs(1).vals(1)),[ends(1) ends(end)]);
    if f.trans, fout = transpose(fout); end
    return
else
    if abs(r(1)  - ends(1)  ) > 1e-14*hs, r = [ends(1); r  ]; end 
    if abs(r(end)- ends(end)) > 1e-14*hs, r = [r; ends(end)];  end
end

% check for double roots (double roots may be quite far apart)
ind = find(diff(r) < 1e-7*hs); cont = 1; 
while ~isempty(ind) && cont < 3
    remove = false(size(r));
    for k = 1:length(ind)
        % Check whether a double root or two single roots close close
        if abs(feval(f,mean(r(ind(k):ind(k)+1)))) < chebfunpref('eps')*100*f.scl
           remove(ind+1) = true;
        end
    end
    r(remove) = [];
    cont = cont+1;
    ind = find(diff(r) < 1e-7*hs);
end

% -------------------------------------------
% Make sure that the domain of definition is not changed
% Rodp added this to fix a bug -- Wiki 22/4/08.
r(end) = ends(end);
r(1) = ends(1);
%---------------------------------------------

nr = length(r);
newints = zeros(1,nr);
newints(1) = ends(1);
ff = [];
c = 0.5912; % evaluate at an arbitrary point in [a,b]
for i = 1:nr-1
    a = r(i); b = r(i+1);
    ff = [ff fun(sign(feval(f,c*a+(1-c)*b)),[a b])];
    newints(i+1) = b;
end
fout = set(f,'funs',ff,'ends',newints,'scl',1,'imps',zeros(1,length(newints)));
fout.imps(1,1) = sign(feval(f,ends(1)));
fout.imps(1,end) = sign(feval(f,ends(end)));