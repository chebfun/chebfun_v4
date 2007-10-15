function h = compose(f,g)

if (isa(f,'function_handle') & isa(g,'chebfun'))
    ends = g.ends;
    nfuns = length(g.funs);
    % To Do: check for singularities of f; they create new intervals
    for i = 1:nfuns
        hfuns{i} = auto(f,g.funs{i});
    end
    h = chebfun(hfuns,ends);
end
    
    