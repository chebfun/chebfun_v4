function len = length(f)
% LENGTH   Number of sample points used by a chebfun.
% LENGTH(F) is the number of sample points used by the chebfun F.
%
% If F is a quasi-matrix, LENGTH(F) is max_k{ LENGTH(F(:,k)) }.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if numel(f)>1
    error('CHEBFUN:length:quasi','LENGTH does not work with CHEBFUN quasi-matrices')
end

len=0; 
for i = 1:f.nfuns
    len = len + f.funs(i).n;
end
