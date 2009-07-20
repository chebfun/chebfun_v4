function [m,v,scl] = unbounded(par,fh,n)
% maps for unbounded domains
% [-inf,b], [-inf,inf], [a,inf]

% Last commit: $Author$: $Rev$:
% $Date$:

a = par(1); b = par(2);
m = struct('for',[],'inv',[],'der',[]);

% map parameter:
if length(par) == 2
    par = [par mappref('parinf')];
end

s = par(3);

if a == -inf && b == inf

    c = par(4);
    
    % Note: scale map with s*(x-c)+c, where c is the location of the max.
    if nargin == 3 && n > 32
        m.for = @(y) (5*s)*trim(y./(1-min(y.^2,1)))+c;
        xpts = m.for(chebpts(n));
        dv = abs(diff(fh(xpts))./diff(xpts));
        xpts = (xpts(1:end-1)+xpts(2:end))/2;
        maxdv = max(dv);
        x1 = xpts(find(dv>0.01*maxdv,1,'first'));
        x2 = xpts(find(dv>0.01*maxdv,1,'last'));
        h = (x2-x1)/2;
        c = (x1+x2)/2;
        % avoid problems that don't decay quadratically at infinity
        if ~isempty(h) && h~=0
            s = h/2.3;
        end
        if abs(c) == inf
            error('somthing is wrong')
        end
    end

    m.inv = @(x) mfor_inf_inf(x,s,c);
    m.for = @(y) (5*s)*trim(y./(1-min(y.^2,1)))+c;
    m.der = @(y) (5*s)*(1+y.^2)./(1-y.^2).^2;
    m.par = [par(1:2) s c];
    scl = max(abs(c-s),abs(c+s));

elseif a == -inf
    
%  Note: scale map with s*(x-b)+b
     if nargin == 3 %&& n > 36
         m.for = @(y) 15*s*trim((y-1)./(y+1))+b;
         xpts = m.for(chebpts(n));
         v = fh(xpts); v = abs(v - v(1));
         h = xpts(find(v>0.01*max(v),1,'first'));
%         % avoid problems that don't decay quadratically at infinity
         if ~isempty(h) && h > xpts(3) && h~=xpts(end)
             s = (b-h)/4.285532316831086;
         end
     end
     
     m.inv = @(x) (15*s+x-b)./(15*s-x+b);
     m.for = @(y) 15*s*trim((y-1)./(y+1))+b;
     m.der = @(y) 15*s*2./(y+1).^2;
     m.par = [par(1:2) s];
     scl = max(abs(b),abs(b-s));


elseif b == inf
    
     if nargin == 3 %&& n > 36
         m.for = @(y) 15*s*trim((y+1)./(1-y))+a;
         xpts = m.for(chebpts(n));
         v = fh(xpts); v = abs(v - v(end));
         h = xpts(find(v>0.01*max(v),1,'last'));
%         % avoid problems that don't decay quadratically at infinity
         if ~isempty(h) && h > xpts(3) && h~=xpts(end)
             s = (h-a)/4.285532316831086;
         end
     end
     
     m.inv = @(x) (-15*s+x-a)./(15*s+x-a);
     m.for = @(y) 15*s*trim((y+1)./(1-y))+a;
     m.der = @(y) 15*s*2./(y-1).^2;
     m.par = [par(1:2) s];
     scl = max(abs(a),abs(a+s));

else
    error('check input')
end

if nargout > 1
    xpts = m.for(chebpts(n));
    v = fh(xpts);
end

m.name = 'unbounded';


function y = mfor_inf_inf(x,s,c)
% This function maps [-inf,inf] to [-1,1]
x = x-c;
a = 5*s;
mask = abs(x)>1;
y = x;
x1 = x(mask);                                     % Large x
x2 = x(~mask);                                    % Small x
y(mask) = 1/2*(sign(x1).*sqrt(a^2./x1.^2+4)-a./x1); % good for large x
y(~mask) = 2*x2./(a+sqrt(a^2+4*x2.^2));             % good for small x

function y = trim(x)
% This function forces x to be in [-10^16,10^16]
y = x;
y(y==inf) = 1e18;
y(y==-inf) = -1e18;
