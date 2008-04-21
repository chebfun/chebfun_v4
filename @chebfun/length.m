function len = length(f)
% LENGTH	Length of a fun
% LENGTH(F) is the number of Chebyshev points N.
% if F is a quasi-matrix, LENGTH(F) is max_k(length(F(k,:))

% Chebfun Version 2.0

if numel(f)>1
    error('LENGTH does not work with CHEBFUN quasi-matrices')
end

len=0;
if ~isempty(f)
    for i = 1:f.nfuns
        len = len + length(f.funs(i));
    end
end