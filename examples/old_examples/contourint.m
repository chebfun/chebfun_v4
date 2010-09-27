function varargout = contourint(f)
% countourint: evaluate a keyhole contour integral of a function f

if nargin == 0
    f = @(x) log(x).*tanh(x)
end

R = 2;      % The outer radius
r = .1;     % the inner radius
ei = .05i;  % 'Width' of the key

% Construct the contour
c = [-R+ei -r+ei -r-ei -R-ei];
s = chebfun('s',[0 1]);
z = [c(1)+s*(c(2)-c(1))
     c(2)*c(3).^s./c(2).^s
     c(3)+s*(c(4)-c(3))
     c(4)*c(1).^s./c(4).^s];
 
% Plot the contour
plot(z), axis equal

% Computer the path integral
I = sum(f(z).*diff(z));

if nargin == 0
    I = I
    Iexact = 4i*pi*log(pi/2)
end

if nargout == 1
    varargout = I;
end
