function h = rdivide(f,g)
% ./	Right chebfun division
% F./G is the chebfun division of G into F.

% R. Pachon, R. Platte 2008.

if (isempty(f) || isempty(g)), h=chebfun; return; end

%scalar & chebfun
if isa(f,'double')
    h=g;
    for i = 1: length(g.funs)
          h.funs{i} = f ./ g.funs{i};
    end
    return;
elseif isa(g,'double')
    h=f;
    for i = 1:length(f.funs)
        h.funs{i}=f.funs{i} ./ g;
    end
    return;
end

if any(g.imps)
    error('Chebfun cannot divide impulses');
end

% chebfuns
[f,g] = overlap(f,g);
h = f;
for k = 1:length(f.ends)-1
    h.funs{k} = f.funs{k} ./ g.funs{k};
end

% impulses
indf=find(f.imps); 
rows=size(f.imps,1);
if any(indf)
    gvals=repmat(feval(g,h.ends),rows);
    h.imps(indf) = f.imps(indf) ./ gvals(indf);
end

