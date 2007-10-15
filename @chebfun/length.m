function m = length(f)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (isempty(f)) 
    m=0;
else
    nfuns = length(f.funs);
    m=0;
    for i = 1:nfuns
        m = m + length(get(f.funs{i},'val'));
    end
end