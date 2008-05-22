function out = std(f)
% STD	Standard deviation.
% STD(F) is the standard deviation of the chebfun F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

out = sqrt(var(f));