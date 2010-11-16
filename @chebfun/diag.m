function A = diag(f,d)
% DIAG   Pointwise multiplication operator.
% A = DIAG(F) produces a chebop that stands for pointwise multiplication by
% the chebfun F. The result of A*G is identical to F.*G.
%
% A = DIAG(F,D) is similar, but restricts the domain of F to D.
%
% See also domain/diag, chebop, linop/mtimes.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

if nargin < 2, d = domain(f); else f = restrict(f,d); end

A = diag(d, f); % Call domain/diag.

% oper = @(u) times(f,u);
% A = linop( @(n) mat(n), oper, f);
%                              
%     function m = mat(n)
%     breaks = []; map = [];
%     if iscell(n)
%         if numel(n) > 1, map = n{2}; end
%         if numel(n) > 2, breaks = n{3}; end
%         if isa(breaks,'domain'), breaks = breaks.endsandbreaks; end
%         n = n{1};
%     end
%     
%     if ~isempty(breaks) 
%         if isa(breaks,'domain'), breaks = breaks.ends; end
%         if numel(breaks) == 2 && all(breaks==d.ends([1 end]))
%             % Breaks are the same as the domain ends. Set to [] to simplify.
%             breaks = [];
%         elseif numel(breaks) > 2
%             numints = numel(breaks)-1;
%             if numel(n) == 1, n = repmat(n,1,numints); end
%             if numel(n) ~= numints
%                 error('CHEBFUN:diag:numints','Vector N does not match domain D.');
%             end
%         end
%     end
% 
%     if isempty(map) || isempty(breaks)
%         % Not maps and breaks
%         if isempty(breaks), breaks = d.ends([1 end]); end
%         xpts = chebpts(n,breaks);
%         if ~isempty(map)
%             if isstruct(map), map = map.for; end
%             xpts = map(xpts);
%         end
%         xpts = trim(xpts);
%     else
%         % Breaks and maps
%         csn = [0 cumsum(n)];
%         xpts = zeros(csn(end),1);
%         if iscell(map) && numel(map) == 1
%             map = map{1};
%         end
%         mp = map.for;
%         for k = 1:numints
%             if numel(map) > 1
%                 if iscell(map), mp = map{k}.for; end
%                 if isstruct(map), mp = map(k).for; end
%             end
%             if isstruct(mp), mp = mp.for; end
%             ii = csn(k)+(1:n(k));
%             xpts(ii) = mp(chebpts(n(k)));
%         end
%     end    
%     
%     m = spdiags( feval( f, xpts ) ,0,sum(n),sum(n));
%     end
% 
%     function y = trim(x)
%     % This function forces x to be in [-10^16,10^16]
%     y = x;
%     y(y==inf) = 1e18;
%     y(y==-inf) = -1e18;
%     end

end