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
N = 15;   % grid size for finite difference computations in loop.

% Interval too small for edge detection, switch to bisection!
if (b-a)^nder < realmin
    return
end

% Compute norm_inf of first nder derivatives. FD grid size is 50.
[na,nb,maxd] = maxder(f, a, b, nder, 50);
maxd1 = maxd;
%[na,nb,maxd] = maxder(f, na(nder), nb(nder), nder, N); 

% Keep track of endpoints.
ends = [na(nder) nb(nder)]; 

% Main loop
while maxd(nder) ~= inf && ~isnan(maxd(nder)) &&  diff(ends) > eps*hs 
    maxd1 = maxd(1:nder);                                  % Keep track of max derivatives
    [na,nb,maxd] = maxder(f, ends(1), ends(2), nder, N);   % compute maximum derivatives and interval
        nder = find( (maxd > (5.5-(1:nder)').*maxd1) & (maxd > 10*vs./hs.^(1:nder)') , 1, 'first' );      % find proper nder
        if isempty(nder)  
            return                                         % derivatives are not gowing, return edge =[]
        elseif nder == 1 && diff(ends) < 1e-3*hs
            edge = findjump(f, ends(1) ,ends(2), hs, vs);  % blow up in first derivative, use findjump
            return
        end
    ends = [na(nder) nb(nder)];
end

edge = mean(ends);
%  if any(maxd1 > 1e+15*vs./hs.^(1:length(maxd1))')            % Blowup detected?
%     edge = mean(ends);
%  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edge = findjump(f, a, b, hs, vs)
% Detects a blowup in first the derivative and uses bisection to locate the
% edge.

edge = [];                                  % Assume no edge has been found
ya = f(a); yb = f(b);                       % compute values at ends
maxd = abs(ya-yb)/(b-a);                    % estimate max abs of the derivative
% If derivative is very small, this is probably a false edge
if maxd < 1e-5 * vs/hs
    return
end
cont = 0;                                   % keep track how many times derivative stoped growing
e1 = (b+a)/2;                               % estimate edge location
e0 = e1+1;                                  % force loop

% main loop
% Note that maxd = inf whenever dx < realmin.
while (cont < 2 || maxd == inf) && e0 ~= e1 
    c = (a+b)/2; yc = f(c);                 % find c at the center of the interval [a,b]
    dy1 = abs(yc-ya); dy2 = abs(yb-yc);     % find the undivided difference on each side of interval
    maxd1 = maxd;                           % keep track of maximum value
    if dy1 > dy2
       b = c; yb = yc;                      % blow-up seems to be in [a,c]
       maxd = dy1/(b-a);                       % upddate maxd
    else
       a = c; ya = yc;                      % blow-up seems to be in [c,b]
       maxd = dy2/(b-a);
    end 
    e0 = e1; e1 = (a+b)/2;                  % update edge location. 
    if maxd < maxd1*(1.5), cont = cont + 1; end  % test must fail twice before breaking the loop.
end

if (e0 - e1)<=eps(e0)
   yright = f(b+eps(b));                   % Look at the floting point at the right
   if abs(yright-yb) > eps*100*vs          % if there is a small jump, that is it!
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
x = [a+(0:N-2)*dx b].';  
dy = f(x);

% main loop (through derivatives), undivided differenes
for j = 1:nder
    dy = diff(dy);
    x = (x(1:end-1)+x(2:end))/2;    
    [maxd(j),ind] = max(abs(dy));
    if ind>1,            na(j) = x(ind-1); end
    if ind<length(x)-1,  nb(j) = x(ind+1); end
end
if dx^nder <= eps(0), maxd= inf+maxd; % Avoid divisions by zero!
else maxd = maxd./dx.^(1:nder)';      % get norm_inf of derivatives.
end
