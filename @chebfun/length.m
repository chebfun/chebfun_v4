function len = length(f)
% LENGTH   Number of sample points used by a chebfun.
% LENGTH(F) is the number of sample points used by the chebfun F.
%
% If F is a quasi-matrix, LENGTH(F) is max_k{ LENGTH(F(:,k)) }.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if numel(f)>1
    error('LENGTH does not work with CHEBFUN quasi-matrices')
end

len=0;
if ~isempty(f)
    for i = 1:f.nfuns
        len = len + length(f.funs(i));
    end
end