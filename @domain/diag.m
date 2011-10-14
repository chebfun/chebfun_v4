function A = diag(f,d)
% DIAG   Pointwise multiplication operator. 
% A = DIAG(F,D) produces a chebop that stands for pointwise multiplication 
% by the function F on the domain D. 
%
% See also chebfun/diag, chebop, linop/mtimes

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin < 2
    error('CHEBFUN:domain:diag:nargin','Two inputs required to domain/diag.');
end

% Switch f and d (as in a call from chebfun/diag
if isa(f,'domain')
    tmp = f; f = d; d = tmp; 
end

f = set(f,'funreturn',0);

% Define the oparray
if isa(f,'chebfun')
    if numel(f) > 1
        error('CHEBFUN:domain:diag:quasi','Quasimatrix input not allowed.');
    end
    oper = @(u) times(f,u);
else
    oper = @(u) chebfun(@(x) feval(f,x).*feval(u,x),d);
end

A = linop( @(n) mat(n), oper, d  );
A.isdiag = 1;

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

    if isempty(breaks)
        % No breaks
        if isempty(map)
            xpts = chebpts(n,d.ends([1 end]));
        else
            if isstruct(map), map = map.for; end
            xpts = map(chebpts(n));
        end
        xpts = trim(xpts);
        fx = feval( f, xpts );
    elseif isempty(map)
        % No maps
        xpts = chebpts(n,breaks);
        xpts = trim(xpts);
        fx = feval( f, xpts );
%         tol = 100*chebfunpref('eps')*f.scl;
%         dxloc = find(abs(diff(xpts)<tol));
        dxloc = cumsum(n(1:end-1));
        fx(dxloc) = feval(f, xpts(dxloc), 'left');
        fx(dxloc+1) = feval(f, xpts(dxloc), 'right');
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
        fx = feval( f, xpts );
        dxloc = csn(2:end-1);
        fx(dxloc) = feval(f, xpts(dxloc), 'left');
        fx(dxloc+1) = feval(f, xpts(dxloc), 'right');
    end  
    m = spdiags( fx ,0,sum(n),sum(n));
    end

    function y = trim(x)
    % This function forces x to be in [-10^16,10^16]
    y = x;
    y(y==inf) = 1e18;
    y(y==-inf) = -1e18;
    end

end