function varargout = polyfit(x,y,n,d)  
%POLYFIT Fit polynomial to a chebfun.
%   F = POLYFIT(X,Y,N,D) returns a chebfun F on the domain D which 
%   corresponds to the polynomial of degree N that fits the data (X,Y) 
%   in the least-squares sense.
%
%   See also polyfit, chebfun/polyfit

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Nick Hale  09/02/2010

if length(x)~=length(y)
    error('CHEBFUN:domain:polyfit:lengths', ...
        'Length of X must equal length(Y).');
end

% if nargout > 1
%     error('CHEBFUN:domain:polyfit:nargout', ...
%         'domain/polyfit only supports 1 output value.');
% end

if nargout > 2
    error('CHEBFUN:domain:polyfit:nargout', ...
        'domain/polyfit only supports 2 output values.');
end

if isa(n,'domain')
    d = n;
    n = length(y);
end

%% ----------------- method 1 -------------------
if nargout == 1
    p = polyfit(x,y,n);
else
    [p s] = polyfit(x,y,n);
end
    
f = chebfun(@(x) polyval(p,x),d,length(p));

varargout{1} = f;
if nargout > 1
    varargout{2} = s;
end

return
%% ----------------- method 2 -------------------

% Q = legpoly((0:n),d);
% Qx = Q(x,:);
% 
% varargout{1} = Q*(Qx\y);

