function E = feval(d,s,lr)
% FEVAL  Evaluation functional.
% E = FEVAL(D,S) returns a linop representing the functional of evaluation
% of a chebfun at the points in vector S. If f is a chebfun also defined on
% the domain D, then E*f will return a length(S)-by-1 vector equal to 
% f(S(:)).
%
% Example:
%
%  E = feval(domain(-1,2),[-1;0;2]);  % evaluate at endpoints and one other
%  format short
%  E(5)   % note first and last rows are like the identity
%    ans =
%       1.0000         0         0         0         0
%      -0.1728    0.6166    0.6914   -0.2215    0.0864
%            0         0         0         0    1.0000
%
%  f = chebfun(@(x) cos(x)./(1+x.^2),[-1 2]); 
%  format long, [f([-1;0;2]), E*f]
%    ans =
%       0.270151152934070   0.270151152934070
%       1.000000000000000   1.000000000000000
%      -0.083229367309428  -0.083229367309428
%
% See also linop, chebfun/feval.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin > 2
    if ~any(strcmpi(lr,{'left','right'}));
        if ischar(lr)
            msg = sprintf('Unknown input argument "%s".',lr);
            error('CHEBFUN:feval:leftrightchar',msg);
        else
            error('CHEBFUN:feval:leftright','Unknown input argument.');
        end
    end
else
    lr = [];
end

a = d.ends(1);  b = d.ends(end);
x = 2*(s(:)-a)/(b-a) - 1;
if isempty(lr)
    E = linop(@mat2,@(u) feval(u,s(:)),d);
else
    E = linop(@mat2,@(u) feval(u,s(:),lr),d);
end

    function P = mat2(n)
        breaks = []; map = [];
        if iscell(n)
            if numel(n) > 1, map = n{2}; end
            if numel(n) > 2, breaks = n{3}; end
            n = n{1};
        end
        
        % Force a default map for unbounded domains.
        if any(isinf(d)) && isempty(map), map = maps(d); end
        % Inherit the breakpoints from the domain.
        breaks = union(breaks, d.ends);
        if isa(breaks,'domain'), breaks = breaks.ends; end
        if numel(breaks) == 2 && all(breaks==d.ends([1 end]))
            % Breaks are the same as the domain ends. Set to [] to simplify.
            breaks = [];
        elseif numel(breaks) > 2
            numints = numel(breaks)-1;
            if numel(n) == 1, n = repmat(n,1,numints); end
            if numel(n) ~= numints
                error('DOMAIN:feval:numints','Vector N does not match domain D.');
            end
        end
        
        if isempty(map) && isempty(breaks)
            % Standard case
            P = barymat(x,chebpts(n));
        elseif isempty(breaks)
            % Map / no breaks
            if isstruct(map), map = map.for; end
            P = barymat(x,map(chebpts(n)));
        elseif isempty(map)
            % Breaks / no map
            P = barymatp(x,n,breaks,[],lr);
        else
            % Breaks and maps
            P = barymatp(x,n,breaks,map,lr);
        end   
    end

end