function A = diag(f,d)
% DIAG   Pointwise multiplication operator. 
% A = DIAG(F,D) produces a chebop that stands for pointwise multiplication 
% by the function F on the domain D. 
%
% See also chebfun/diag, chebop, linop/mtimes
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Last commit: $Author$: $Rev$:
%  $Date$:

if nargin < 2
    error('CHEBUFN:domain:diag:nargin','Two inputs required to domain/diag.');
end

% Switch f and d (as in a call from chebfun/diag
if isa(f,'domain')
    tmp = f; f = d; d = tmp; 
end

% Define the oparray
if isa(f,'chebfun')
    oper = @(u) times(f,u);
else
    oper = @(u) chebfun(@(x) feval(f,x).*feval(u,x),d);
end

A = linop( @(n) mat(n), oper, d  );

    % Define the mat
    function m = mat(n)
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
    if numel(breaks) == 2
        % Breaks are the same as the domain ends. Set to [] to simplify.
        breaks = [];
    elseif numel(breaks) > 2
        numints = numel(breaks)-1;
        if numel(n) == 1, n = repmat(n,1,numints); end
        if numel(n) ~= numints
            error('DOMAIN:diag:numints','Vector N does not match domain D.');
        end
    end

    if isempty(map) || isempty(breaks)
        % Not maps and breaks
        if isempty(breaks), breaks = d.ends([1 end]); end
        xpts = chebpts(n,breaks);
        if ~isempty(map)
            if isstruct(map), map = map.for; end
            xpts = map(xpts);
        end
        xpts = trim(xpts);
    else
        % Breaks and maps
        csn = [0 cumsum(n)];
        xpts = zeros(csn(end),1);
        if iscell(map) && numel(map) == 1
            map = map{1};
        end
        mp = map.for;
        for k = 1:numints
            if numel(map) > 1
                if iscell(map), mp = map{k}.for; end
                if isstruct(map), mp = map(k).for; end
            end
            if isstruct(mp), mp = mp.for; end
            ii = csn(k)+(1:n(k));
            xpts(ii) = mp(chebpts(n(k)));
        end
    end    
    
    m = spdiags( feval( f, xpts ) ,0,sum(n),sum(n));
    end

    function y = trim(x)
    % This function forces x to be in [-10^16,10^16]
    y = x;
    y(y==inf) = 1e18;
    y(y==-inf) = -1e18;
    end

end