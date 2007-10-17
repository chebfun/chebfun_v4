function h = times(f,g)
% .*	Chebfun multiplication
% F.*G multiplies chebfuns F and G or a chebfun by a scalar if either F or G is
% a scalar.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (isempty(f) | isempty(g)), h=chebfun; return; end
if isa(f,'double')
    h=g;
    for i = 1: length(g.funs)
          h.funs{i} = f * g.funs{i};
    end
    return;
elseif isa(g,'double')
    h=f;
    for i = 1:length(f.funs)
        h.funs{i}=f.funs{i} * g;
    end
    return;
end
[hends, hf, hg, ord] = overlap(f.ends,g.ends);
x = fun('x',1);
for i = 1:size(ord,2)-1
    fcheb = f.funs{ord(1,i)}; gcheb = g.funs{ord(2,i)};
    hfuns{i} = fcheb(hf(1,i)*x+hf(2,i)) .* gcheb(hg(1,i)*x+hg(2,i));
end
ord = [[1;1] diff(ord,1,2)];
frows = size(f.imps,1); grows = size(g.imps,1);
maxrows = max(frows,grows);
fim = zeros(max(frows,grows),length(hends));  gim = fim;
fim(1:frows,find(ord(1,:))) = f.imps; 
gim(1:grows,find(ord(2,:))) = g.imps;
if any(intersect(fim,gim,'rows')),
    error('Chebfun cannot multiply two impulses at the same location')
end
S.type = '()';
S.subs = {hends};
fh = subsref(f,S); gh = subsref(g,S);

fim = fim.*gh(ones(maxrows,1),:); fim(isnan(fim)) = 0;
gim = gim.*fh(ones(maxrows,1),:); gim(isnan(gim)) = 0;
himps = fim + gim;
h = chebfun(hfuns,hends);
set(h,'imps',himps);