function h = rdivide(f,g)
% ./	Right chebfun division
% F./G is the chebfun division of G into F.
if (isempty(f) | isempty(g)), h=chebfun; return; end
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
[hends, hf, hg, ord] = overlap(f.ends,g.ends);
x = fun('x',1);
for i = 1:size(ord,2)-1
    fcheb = f.funs{ord(1,i)}; gcheb = g.funs{ord(2,i)};
    hfuns{i} = fcheb(hf(1,i)*x+hf(2,i)) ./ gcheb(hg(1,i)*x+hg(2,i));
end
ord = [[1;1] diff(ord,1,2)];
frows = size(f.imps,1); grows = size(g.imps,1);
fim = zeros(max(frows,grows),length(hends));  gim = fim;
fim(1:frows,find(ord(1,:))) = f.imps; 
S.type = '()';
S.subs = {hends(2:end)};
gh = subsref(g,S);
himps = fim(2:end)./gh(ones(grows,1),:); 
himps = [zeros(size(himps,1),1) himps];
h = chebfun(hfuns,hends);
set(h,'imps',himps);