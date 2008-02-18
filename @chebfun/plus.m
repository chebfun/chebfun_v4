function h = plus(f,g)
% +	Plus
% F + G adds chebfuns F and G or a scalar to a chebfun if either F or G is 
% a scalar.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
% Rodrigo Platte, Feb. 2008
if (isempty(f) | isempty(g)), h=chebfun; return; end

% scalar + chebfun
if isa(f,'double')
    h=g;
    for i = 1: length(g.funs)
          h.funs{i} = f + g.funs{i};
    end
    return;
elseif isa(g,'double')
    h=f;
    for i = 1:length(f.funs)
        h.funs{i}=f.funs{i} + g;
    end
    return;
end

% chebfun + chebfun
[f,g] = overlap(f,g);
h = f;
for k = 1:length(f.ends)-1
    h.funs{k} = f.funs{k} + g.funs{k};
end
set(h,'imps',f.imps+g.imps);
