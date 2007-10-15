function K = isanimpulse(f)

if isa(f,'chebfun') 
    if not(isempty(get(f,'imps')))
        K = true;
    else
        K = false;
    end
else
    K = false;
end

        