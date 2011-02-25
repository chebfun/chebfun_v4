function [x w v] = chebpts(n,d,kind)
%CHEBPTS  Chebyshev points in [-1,1].
%   CHEBPTS(N) returns N Chebyshev points of the second kind in [-1,1].
%
%   CHEBPTS(N,D) scales the nodes and weights for the domain D. D can be
%   either a domain object or a vector with two components. If the interval
%   is infinite, the map is chosen to be the default 'unbounded map' with
%   mappref('parinf') = [1 0] and mappref('adaptinf') = 0. 
%
%   If D is a domain with breakpoints (or a vector of length greater than 2)
%   and N a vector of length(D.BREAKS)+1 (or length(D)-1), then CHEBPTS
%   returns a column vector of the stacked N(k) Chebyshev points on the 
%   subintervals D(k:k+1). If length(N) is 1, then D is taken as D.ENDS.
%
%   [X W] = CHEBPTS(N,D) returns also a row vector of the (scaled) weights 
%   for Clenshaw-Curtis quadrature (compjuted using [1]). For nodes and 
%   weights of Gauss-Chebyshev quadrature, use [X W] = JACPTS(N,-.5,-.5,D).
%
%   [X W V] = CHEBPTS(N,D) returns, in addition to the points and Gauss 
%   quadrature weights, the barycentric weights corresponding to the points X.
%
%   [X W V] = CHEBPTS(F) returns the Chebyshev nodes and weights
%   corresponding to the domain and length of the chebfun F.
%
%   CHEBPTS(N,KIND) or CHEBPTS(N,D,KIND) returns Chebyshev points of the
%   first kind if KIND = 1 and second kind if KIND = 2 (default).
%   Note that chebpts will always return second kind points, regardless of
%   the value of 'chebkind' in chebfunpref.
%
%   See also legpts, jacpts, lagpts, and hermpts.

%   Copyright 2011 by The University of Oxford and The Chebfun Developers. 
%   See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

%   [1] Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis
%   quadrature rules", BIT Numerical Mathematics 43 (1), pp 1--18 (2004).


% Intialise
x = []; w = []; v = [];
scale = false;

% Parse the inputs
if isa(n,'chebfun')
    if numel(n) > 1
        error('CHEBFUN:chebpts:quasi','chebpts does not work with quasi-matrices');
    end
    d = get(n,'ends');
    if nargin == 1, kind = 2; end
    if nargout == 1
        for k = 1:n.nfuns;
            nk = n.funs(k).n;
            x = [x ; chebpts(nk,d(k:k+1),kind)];
        end
    elseif nargout == 2
        for k = 1:n.nfuns;
            nk = n.funs(k).n;
            [xk wk vk] = chebpts(nk,d(k:k+1),kind);
            x = [x ; xk]; w = [w  wk];
        end
    else
        for k = 1:n.nfuns;
            nk = n.funs(k).n;
            [xk wk vk] = chebpts(nk,d(k:k+1),kind);
            x = [x ; xk]; w = [w  wk]; v = [v ; vk];
        end
    end        
    return
elseif nargin == 1
    d = [-1 1];
    kind = 2;
elseif nargin == 2
    if isa(d,'domain')
       scale = true;
       kind = 2;
    elseif length(d) == 1
       kind = d;
       d = [-1 1];
    else
       scale = true;
       kind = 2; 
    end
elseif nargin >= 3
    scale = true; 
end

if isa(d,'domain')
    d = d.endsandbreaks;   
end
if isempty(d) || ~any(n)
    return % Return empty vector if domain is empty or n == 0
end
if numel(n) == 1
    d = d([1 end]);
end

% Deal with the piecewise case (where d has breakpoints and n is a vector).
numints = numel(d)-1; 
if numints > 1
    if numel(n) ~= numints
        error('CHEBFUN:chebpts:numints','Vector N does not match domain D.'); 
    end
    if nargout == 1
        for k = 1:numints
           x = [x ; chebpts(n(k),d(k:k+1),kind)];
        end
    elseif nargout == 2
        for k = 1:numints
           [xk wk] = chebpts(n(k),d(k:k+1),kind);
           x = [x ; xk]; w = [w  wk];
        end
    else
        for k = 1:numints
           [xk wk vk] = chebpts(n(k),d(k:k+1),kind);
           x = [x ; xk]; w = [w  wk]; v = [v ; vk];
        end
    end
    return
end    

if numel(n) > 1, 
    error('CHEBFUN:chebpts:vecn','Vector N does not match domain D.');
end

if nargin > 1 && (all(d==[-1 1])), scale = false; end

if      strcmpi(kind,'1st'), kind = 1;
elseif  strcmpi(kind,'2nd'), kind = 2; end
        
w = 2; v = 1;
if n <= 0, 
    error('CHEBFUN:chebpts:posinpt','Input should be a positive number');
elseif n == 1,
    x = 0; 
else
    m = n-1;
    if kind == 1
        x = sin(pi*(-m:2:m)/(2*m+2)).';
        if nargout > 1
            % quadrature weights
            w = weights1(n);
        end
        if nargout > 2
            % barycentric weights
            v = sin((2*(0:n-1)+1)*pi/(2*n)).';
            v(2:2:end) = -v(2:2:end);
            if ~mod(n,2), v = v./max(abs(v)); end
        end
    else
        x = sin(pi*(-m:2:m)/(2*m)).';
        if nargout > 1
            % quadrature weights            
            w = weights2(n);
        end
        if nargout > 2
            % barycentric weights
            v = [.5 ; ones(n-1,1)]; 
            v(2:2:end) = -1;
            v(end) = .5*v(end);
        end
    end
end

% rescale x if d is provided:
if scale
    dab = diff(d);
    
    if ~any(isinf(d))
        % finite interval
        x = x/2*dab + (d(1) + dab/2);
        w = dab*w/2;
    else
        % infinite interval
        m = maps(fun,{'unbounded'},d); % use default map
        if nargout > 1
            w = w.*m.der(x.');
            if isinf(d(1)), w(1) = 0; end
            if isinf(d(end)), w(end) = 0; end
        end
        x = m.for(x);
        if kind == 2
            x([1 end]) = d([1 end]);
        end
    end        
end

function w = weights2(n) % 2nd kind
% Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis 
% quadrature rules", BIT Numerical Mathematics 43 (1), p. 001-018 (2004).
if n == 1
     w = 2;
else
    m = n-1;  
    c = zeros(1,n);
    c(1:2:n) = 2./[1 1-(2:2:m).^2 ]; 
    f = real(ifft([c(1:n) c(m:-1:2)]));
    w = [f(1) 2*f(2:m) f(n)];
end

function w = weights1(n) % 1st kind
% Jörg Waldvogel, "Fast construction of the Fejér and Clenshaw-Curtis
% quadrature rules", BIT Numerical Mathematics 43 (1), p. 001-018 (2004).
if n == 1
    w = 2;
else
    l = floor(n/2)+1;
    K = 0:n-l;   
    v = [2*exp(1i*pi*K/n)./(1-4*K.^2)  zeros(1,l)];
    w = real(ifft(v(1:n) + conj(v(n+1:-1:2))));
end
