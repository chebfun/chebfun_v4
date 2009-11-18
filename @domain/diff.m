function D = diff(d,varargin)
% DIFF Differentiation operator.
% D = DIFF(R) returns a chebop representing differentiation for chebfuns
% defined on the domain R.
%
% D = DIFF(R,M) returns the chebop for M-fold differentiation.
%
% D = DIFF(R,G) or DIFF(R,M,G) is the mapped differentiation matrix with 
% the map G.FOR from the map structure G.
%
% See also CHEBOP, CHEBFUN/DIFF.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.

% defaults
m = 1;
if all(isfinite(d.ends))
    map = maps({'linear'},d.ends);
else
    map = [];
end

% parse inputs
if nargin > 1
    while ~isempty(varargin)
        if isstruct(varargin{1})
            map = varargin{1};
        else
            m = varargin{1};
        end
        varargin(1) = [];
    end
end

if isempty(d)
    D = chebop;
    return
    
elseif all(isfinite(d.ends))
    if strcmp(map.name,'linear')
        D = chebop( @(n) diffmat(n)*2/length(d), @(u) diff(u), d, 1 );
    else
%         D = chebop( @(n) diag(1./map.der(chebpts(n)))*diffmat(n), @(u) diff(u), d, 1 );
        D = chebop( @(n) barymat(map.for(chebpts(n))), @(u) diff(u), d, 1 );
    end
else
    if isempty(map)
        map = maps({'unbounded'},d.ends); % use default unbounded map
    end
    D = chebop( @(n) diag(1./map.der(chebpts(n)))*diffmat(n), @(u) diff(u), d, 1 );
end

if m > 1
    D = mpower(D,m);
end

end


function [D1 D2 D3 D4] = barymat(x,w)  
% BARYMAT  Barycentric differentiation matrix with arbitrary weights/nodes.
%  D = BARYMAT(X,W) creates the first-order differentiation matrix with
%       nodes X and weights W.
%
%  D = BARYMAT(X) assumes Chebyshev weights. 
%
%  [D1 D2 D3 D4] = BARYMAT(X,W) returns differentiation matrices of upto
%  order 4.
%
%  All inputs should be column vectors.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: nich $: $Rev: 509 $:
%  $Date: 2009-06-23 19:22:15 +0100 (Tue, 23 Jun 2009) $:

N = length(x)-1;
if N == 0
    N = x;
    x = chebpts(N);
end

if nargin < 2           % Default to Chebyshev weights
    w = [1/2; ones(N-1,1); 1/2].*(-1).^((0:N)'); 
end

ii = (1:N+2:(N+1)^2)';
Dw = repmat(w',N+1,1) ./ repmat(w,1,N+1) - eye(N+1);
Dx = repmat(x ,1,N+1) - repmat(x',N+1,1) + eye(N+1);

D1 = Dw ./ Dx;
D1(ii) = 0; D1(ii) = - sum(D1,2);
if (nargout == 1), return; end
D2 = 2*D1 .* (repmat(D1(ii),1,N+1) - 1./Dx);
D2(ii) = 0; D2(ii) = - sum(D2,2);
if (nargout == 2), return; end
D3 = 3./Dx .* (Dw.*repmat(D2(ii),1,N+1) - D2);
D3(ii) = 0; D3(ii) = - sum(D3,2);
if (nargout == 3), return; end
D4 = 4./Dx .* (Dw.*repmat(D3(ii),1,N+1) - D3);
D4(ii) = 0; D4(ii) = - sum(D4,2);

end