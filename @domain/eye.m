function I = eye(d)
% EYE Identity operator.
% EYE(D) returns a chebop representing the identity for functions defined 
% on the domain D.
%
% See also chebop, linop.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isempty(d)
  I = linop;
else
  I = linop( @(n) makespeye(n), @(u) u, d );
end


    function I = makespeye(n)
    breaks = [];
    if iscell(n)
    %     if numel(n) > 1, map = n{2}; end
        if numel(n) > 2, breaks = n{3}; end
        n = n{1};
    end
    breaks = union(breaks, d.ends);
    if isa(breaks,'domain'), breaks = breaks.ends; end
    if numel(breaks) > 2
        numints = numel(breaks)-1;
        if numel(n) == 1, n = repmat(n,1,numints); end
        if numel(n) ~= numints
            error('DOMAIN:eye:numints','Vector N does not match domain D.');
        end
    end

    I = speye(sum(n));
    end

end