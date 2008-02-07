function h = times(f,g)
% .*	Chebfun multiplication
% F.*G multiplies chebfuns F and G or a chebfun by a scalar if either F or G is
% a scalar.
%

%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
% Rodrigo B. Platte, 2008.
        
if (isempty(f) || isempty(g)), h = chebfun; return; end

% scalar times chebfun
if isa(f,'double')
    h = g;
    for i = 1: length(g.funs)
        h.funs{i} = f * g.funs{i};         
        h = set(h,'imps',f*get(g,'imps'));
    end
    return;
elseif isa(g,'double')
    h=f;
    for i = 1:length(f.funs)
        h.funs{i} = f.funs{i} * g;
        h = set(h,'imps',g*get(f,'imps'));
    end
    return;
end

% product of two chebfuns
[f,g] = newoverlap(f,g);
h = f;
for k = 1:length(f.ends)-1
    h.funs{k} = f.funs{k}.*g.funs{k};
end

% impulses
indf=find(f.imps); indg=find(g.imps);
rows=size(f.imps,1);
if any(indf)
    gvals=repmat(feval(g,h.ends),rows);
    h.imps(indf) = f.imps(indf).*gvals(indf);
end
if any(indg)
    fvals=repmat(feval(f,h.ends),rows);
    h.imps(indg) = g.imps(indg).*fvals(indg);
    [trash,indboth] = intersect(indf,indg);
    h.imps(indboth) = nan;
end