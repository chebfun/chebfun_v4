function out = std(f)
% STD	Standard deviation.
% STD(F) is the standard deviation of the chebfun F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

out = sqrt(var(f));