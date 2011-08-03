function fx = bary(x,gvals,xk,ek)  
% BARY  Barycentric interpolation with arbitrary weights/nodes.
%  P = BARY(X,GVALS,XK,EK) interpolates the values GVALS at nodes 
%  XK in the point X using the barycentric weights EK. 
%
%  P = BARY(X,GVALS) assumes Chebyshev nodes and weights. 
%
%  All inputs should be column vectors.

%  Copyright 2011 by The University of Oxford and The Chebfun Developers. 
%  See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

n = length(gvals);

if any(isnan(gvals))
    fx = NaN(size(x));
    return
end

if n == 1                % The function is a constant
    fx = gvals*ones(size(x));
    return;
end

if nargin < 4            % Default to Chebyshev weights
    ek = [.5 ; ones(n-1,1)]; 
    ek(2:2:end) = -1;
    ek(end) = .5*ek(end);
%     % Weights for 1st kind points (at the moment only second kind should be used)
%     ek = sin((2*(0:n-1)+1)*pi/(2*n)).';
%     ek(2:2:end) = -ek(2:2:end);
end
if nargin < 3            % Default to Chebyshev nodes
    xk = chebpts(n);
end
    
warnstate = warning('off','MATLAB:divideByZero');

if length(x) < length(xk)
    fx = zeros(size(x)); % init return value
    for i = 1:numel(x)
        xx = ek./(x(i)-xk);
        fx(i) = (xx.'*gvals)/sum(xx);
    end      
else
    num = zeros(size(x)); denom = num;
    for i = 1:numel(xk)
        y = ek(i)./(x-xk(i));
        num = num+(gvals(i)*y);
        denom = denom+y;
    end
    fx = num./denom;
end

warning(warnstate);

% clean-up nans
for i=find(isnan(fx(:)))'
    indx = find(x(i)==xk,1);
    fx(i) = gvals(indx);
end


