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
% See also chebop, linop, chebfun/diff.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

%  Last commit: $Author$: $Rev$:
%  $Date$:

% defaults
m = 1;
if all(isfinite(d.ends))
    map = maps(fun,{'linear'},d.ends);    % standard linear map
else
    map = maps(fun,{'unbounded'},d.ends); % default unbounded map
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

if round(m)~=m
    error('CHEBFUN:domain:diff:fracdiff',...
        'Fractional derivatives are not yet supported as operators.');
end

if isempty(d)
    D = linop;
    return
elseif all(isfinite(d.ends))
    if strcmp(map.name,'linear')
        D = linop( @(n) diffmat(n)*2/length(d), @(u) diff(u), d, 1 );
    else
        D = linop( @(n) barymat(map.for(chebpts(n))), @(u) diff(u), d, 1 );
    end
else
    D = linop( @(n) diag(1./map.der(chebpts(n)))*diffmat(n), @(u) diff(u), d, 1 );
    
end

if m > 1, D = mpower(D,m); end

end


%%
% % Above diff(f,2) is in fact diff(diff(f,2)), which corresonds to how
% % chebfuns are differentiated. 
% if isempty(d)
%     D = linop;
%     return
% elseif all(isfinite(d.ends))
%     D = linop( @(n) barymat(map.for(chebpts(n)),[],m), @(u) diff(u,m), d, 1 );   
% else
%     D = linop( @(n) diag(1./map.der(chebpts(n)))*diffmat(n), @(u) diff(u), d, 1 );
%     if m > 1, D = mpower(D,m); end
% end

%%




function Dk = barymat(x,w,k)  
% BARYMAT  Barycentric differentiation matrix with arbitrary weights/nodes.
%  D = BARYMAT(X,W) creates the first-order differentiation matrix with
%       nodes X and weights W.
%
%  D = BARYMAT(X) assumes Chebyshev weights. 
%
%  DK = BARYMAT(X,W,K) returns the differentiation matrice of DK of order K.
%
%  All inputs should be column vectors.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

N = length(x)-1;
if N == 0
    N = x;
    x = chebpts(N);
end

if nargin == 2 && length(w)-1~=N
    if length(w) == 1
        k = w; 
        w = [];
    else
        error('DOMAIN:diff:barymat:lengthin',['Length of weights vector ', ...
        'must match length of points']);
    end
end

if nargin < 2 || isempty(w) % Default to Chebyshev weights
    w = [.5 ; ones(N,1)]; 
    w(2:2:end) = -1;
    w(end) = .5*w(end);
end

if nargin < 3, k = 1; end

ii = (1:N+2:(N+1)^2)';
Dw = repmat(w',N+1,1) ./ repmat(w ,1,N+1) - eye(N+1);
Dx = repmat(x ,1,N+1) -  repmat(x',N+1,1) + eye(N+1);

% k = 1
Dk = Dw ./ Dx;
Dk(ii) = 0; Dk(ii) = - sum(Dk,2);

if k == 1, return; end

% k = 2
Dk = 2*Dk .* (repmat(Dk(ii),1,N+1) - 1./Dx);
Dk(ii) = 0; Dk(ii) = - sum(Dk,2);

% higher orders
for j = 3:k
    Dk = j./Dx .* (Dw.*repmat(Dk(ii),1,N+1) - Dk);
    Dk(ii) = 0; Dk(ii) = - sum(Dk,2);
end

end