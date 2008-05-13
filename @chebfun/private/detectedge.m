function edge = detectedge(f,a,b,hs,vs)
% EDGE = DETECTEDGE(F,A,B,HS,VS)
% Edge detection code used in auto.m 
%
% Detects a blowup in first, second, third, or fourth derivatives of 
% F in [A,B].
% HS is the horizontal scale and VS is the vertical scale.
% If no edge is detected, EDGE=[] is returned.
%

% Rodrigo Platte, 2008. 

% Assume no edge is found
edge = [];

nder = 4; % Number of derivatives to be tested
cont = 1; % cont is used to decide whether switch derivative tests.
N = 15;   % grid size for finite difference computations in loop.

% Compute norm_inf of first nder derivatives. FD grid size is 50.
[na,nb,maxd] = maxder(f, a, b, nder, 50);

% Keep track of endpoints.
ends = [na(nder) nb(nder)]; 

% Main loop
while maxd(nder) ~= inf && ~isnan(maxd(nder)) &&  diff(ends) > eps*hs 
    cont = cont + 1;
    maxd1 = maxd(1:nder);                                  % Keep track of max derivatives
    [na,nb,maxd] = maxder(f, ends(1), ends(2), nder, N);   % compute maximum derivatives and interval
    if cont < 3                                            % If cont < 3, choose the proper test (nder)
        nder = find( maxd > 1.2*maxd1, 1, 'first' );       % find proper nder
        if isempty(nder)  
            return                                         % derivatives are not gowing, return edge =[]
        elseif nder == 1
            edge = findjump(f, ends(1) ,ends(2), hs, vs);  % blow up in first derivative, use findjump
            return
        end
    elseif maxd(nder) < 1.2*maxd1(nder)                    
        return                                             % derivatives don't seem to blowup, edge =[]
    end
    ends = [na(nder) nb(nder)];
end
    
if any(maxd1 > 1e+8*vs./hs.^(1:length(maxd1))')            % Blowup detected?
    edge = mean(ends);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edge = findjump(f, a, b, hs, vs)
% Detects a blowup in first the derivative and uses bisection to locate the
% edge.

edge = [];                                  % Assume no edge has been found
ya = f(a); yb = f(b);                       % compute values at ends
dx = b-a; maxd = abs(ya-yb)/dx;             % estimate max abs of the derivative
cont = 0;                                   % keep track how many times derivative stoped growing
e1 = (b+a)/2;                               % estimate edge location
e0 = e1+1;                                  % force loop

% main loop
while (cont < 2 || maxd == inf) && e0 ~= e1
    c = (a+b)/2; yc = f(c); dx = dx/2;      % find c at the center of the interval [a,b]
    dy1 = abs(yc-ya); dy2 = abs(yb-yc);     % find the undivided difference on each side of interval
    maxd1 = maxd;                           % keep track of maximum value
    if dy1 > dy2
       b = c; yb = yc;                      % blow-up seems to be in [a,c]
       maxd = dy1/dx;                       % upddate maxd
    else
       a = c; ya = yc;                      % blow-up seems to be in [c,b]
       maxd = dy2/dx;
    end 
    e0 = e1; e1 = (a+b)/2;                  % update edge location. 
    if maxd < maxd1*(1.1), cont = cont + 1; end  % test must fail twice before breaking the loop.
end

% Blowup in first derivative may be difficult to detect, as in f(x)=sqrt(x)
% where maxd ~ 1e8. So check the norm inf of the second derivative!
[na,nb,maxd] = maxder(f,a,b,2,4);   
if maxd(end) > 1e+13*vs/hs^2               % If it blows up, find exact location    
   yright = f(b+eps(b));                   % Look at the floting point at the right
   if abs(yright-yb) > eps(b)*100*norm([yright,ya,yb],inf) % if there is a small jump, that is it!
       edge = b;
   else
       edge = a;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [na,nb,maxd] = maxder(f,a,b,nder,N)
% Compute the norm_inf of derivatives 1:nder

% initial setup
maxd = zeros(nder,1);
na = a*ones(nder,1); nb = b*ones(nder,1);

% generate FD grid points and values
dx = (b-a)/(N-1); 
x = [a+(0:N-2)*dx b];  
dy = f(x);

% main loop (through derivatives), undivided differenes
for j = 1:nder
    dy = diff(dy);
    x = (x(1:end-1)+x(2:end))/2;    
    [maxd(j),ind] = max(abs(dy));
    if ind>2,            na(j) = x(ind-1); end
    if ind<length(x)-2,  nb(j) = x(ind+1); end
end
if dx^nder <= eps(0), maxd= inf+maxd; % Avoid divisions by zero!
else maxd = maxd./dx.^(1:nder)';      % get norm_inf of derivatives.
end
