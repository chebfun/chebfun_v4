function [g gsing] = cumsum(g)
% CUMSUM	Indefinite integral
% CUMSUM(G) is the indefinite integral of the fun G.
% If the fun G of length n is represented as
%
%       SUM_{r=0}^{n-1} c_r T_r(x)
%
% its integral is represented with a fun of length n+1 given by
%
%       SUM_{r=0}^{n} C_r T_r (x)
% 
% where C_0 is determined from the constant of integration as
% 
%       C_0 = SUM_{r=1}^{n} (-1)^(r+1) C_r;
%
% C_1 = c_0 - c_2/2, and for r > 0,
%
%       C_r = (c_{r-1} - c_{r+1})/(2r),
%
% with c_{n+1} = c_{n+2} = 0.
%
% See "Chebyshev Polynomials" by Mason and Handscomb, CRC 2002, pg 32-33.
%
% For functions with exponents, things are more complicated. We switch to 
% a Jacobi polynomial representation with the correct weights. We can then
% integrate all the terms for r > 0 exactly.
%
% In these cases [F1 F2] = cumsum(G) will return two funs, the first F1 will
% be the a smooth part (or a smooth part with exponents), whilst the 2nd F2
% will contain the terms which are harder to represent (using a sing-type
% map). (This is very experimental!)
%
% There is limited support for functions whose indefinite integral is also 
% unbounded (i.e. G.exps <=1). In particular, the form of the blow up must
% be an integer, and G may only have exponents at one end of it's interval.
%
% Functions with both exponents and nonlinear maps can only be dealt with 
% by switching to and from a linear map, and are therefore often very slow.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

ends = g.map.par(1:2);
    
% linear map (simplest case)
if strcmp(g.map.name,'linear')
    
    if isempty(g), return, end
    
    if ~any(g.exps)  
        g.vals = g.vals*g.map.der(0); % From change of variables to [-1,1]
        g = cumsum_unit_interval(g);
        gsing = fun(0,g.map.par(1:2));
    elseif any(g.exps<=-1)
        if nargout > 1 
            [g gsing] = unbdnd(g);
        else
            g = unbdnd(g);
        end
    else
        if nargout > 1 
            [g gsing] = jacsum(g);
        else
            g = jacsum(g);
        end
    end
    
% Infinite intervals
elseif any(isinf(ends))
    if any(g.exps)
        exps = g.exps;
        map = g.map;
        s = map.par(3);
        g = setexps(g,exps-2*logical(exps));
        g.map = linear([-1,1]);
        
        g = cumsum(g);
        if strcmp(g.map.name,'linear')
            g.map = map;
        else
%             error('FUN:cumsum:infmap','Singularities introduced by cumsum in inf map.');
            warning(['FUN:cumsum:infmap','Singularities introduced by cumsum in inf map. Result may be inaccurate.']);
            pref = chebfunpref;   pref.exps = [g.exps(1) g.exps(2)];
            g = fun(@(x) feval(g,x),linear([-1,1]),pref);
            g.map = map;
        end
        
%         [g gsing] = cumsum(g);
%         if strcmp(gsing.map.name,'linear')
%             g = g + gsing;
%             g.map = map;
%         else
% %             error('FUN:cumsum:infmap','Singularities introduced by cumsum in inf map.');
%             warning(['FUN:cumsum:infmap','Singularities introduced by cumsum in inf map. Result may be inaccurate.']);
%             pref = chebfunpref;   pref.exps = [gsing.exps(1) gsing.exps(2)];
%             pref.exps
%             pref.scale = max(gsing.scl.v,g.scl.v);
%             gsing = fun(@(x) feval(gsing,x),linear([-1,1]),pref);
%             g = g + gsing;
%             g.map = map;
%         end
        
        return
    end

    % constant case
    if g.n == 1
        if abs(g.vals) <= chebfunpref('eps')*10*g.scl.v
            g.vals = 0; g.scl.v = 0;
            return
        end
        s = g.map.par(3);
        if all(isinf(ends))
            rescl = (.5/(5*s))*.5;  % Why is this the right constant!?
            g.vals = g.vals*rescl*[-1 ; 1];
            g.exps = [-1 -1];
        elseif isinf(ends(1)), 
            g.exps = [-1 0];
            g.vals = g.vals*[-1 ; 0];
        elseif isinf(ends(2))
            g.exps = [0 -1]; 
            g.vals = g.vals*[0 ; 1];
        end
        return
    end
    
    vends = g.vals([1,end]);
    tol = max(10*chebfunpref('eps'),1e-8)*g.scl.v; % Loose tolerance
    
    % Linear case (must be like f=c*(1/x) and integral diverges)
    if g.n == 2
        if all(abs(g.vals) <= chebfunpref('eps')*10*g.scl.v)
            g.vals = 0; g.scl.v = 0;
        else
            error('FUN:cumsum:unbdblow','Representation of functions that blowup ',...
                'logarithmically on unbounded intervals has not been implemented in this version')
        end
        return
    end
    
    y = chebpts(g.n, 2);
    pref = chebfunpref;
    pref.extrapolate = true;
    pref.eps = pref.eps*10;

    % Quadratic case (must be like f = c*(1/x^2) +b) -- semi-bounded case
    if g.n == 3 && sum(isinf(ends)) == 1
        vals = g.vals;
        g.vals = vals.*g.map.der(y);
        g = extrapolate(g,pref,y);
        g = cumsum_unit_interval(g);   
        if (isinf(ends(1)) && abs(vals(1))/norm(vals,inf) > 10*eps) || ...
                (isinf(ends(2)) && abs(vals(3))/norm(vals,inf) > 10*eps)
            error('FUN:cumsum:unbdblow','Representation of functions that blowup on unbounded intervals has not been implemented in this version')
        end
        return
    end
           
    % Check if not zero at infinity (unbounded integral, simple case)
    if isinf(ends(1))
        % integral is +-inf if endpoint value isn't zero
        if abs(g.vals(1)) > tol
            error('FUN:cumsum:unbdblow','Representation of functions that blowup on unbounded intervals has not been implemented in this version')
        end
    end
    if isinf(ends(2))
        % integral is +- inf endpoint value isn't zero
        if abs(g.vals(end)) > tol
            error('FUN:cumsum:unbdblow','Representation of functions that blowup on unbounded intervals has not been implemented in this version')
        end
    end
    
    % Extract roots (type of trick)
    % Besides having a zero at (+- 1), the fun should decrease towards the
    % endpoint. Decaying faster than 1/x^2 results in a double root.
    % ---------------------------------------------------------------------
    
    if isinf(ends(2))
        gtmp = g; gtmp.vals = gtmp.vals./(1-y);
        gtmp = extrapolate(gtmp,pref,y);
        if abs(gtmp.vals(end)) > 1e3*tol &&  diff(gtmp.vals((end-1:end))./diff(y(end-1:end))) > -g.scl.v/g.scl.h
            error('FUN:cumsum:unbdblow','Representation of functions that blowup on unbounded intervals has not been implemented in this version')
        else
            g.vals(end) = 0;
            if abs(gtmp.vals(end)) > tol
                warning('FUN:cumsum:slowdecay','Representation is likely inaccurate')
            end
        end
        
    end
    if isinf(ends(1))
        gtmp = g; gtmp.vals = gtmp.vals./(1+y);
        gtmp = extrapolate(gtmp,pref,y);
        if abs(gtmp.vals(1)) > 1e3*tol && diff(gtmp.vals(1:2)./diff(y(1:2))) < g.scl.v/g.scl.h
            error('chebfun:cumsum:unbdblow','Representation of functions that blowup on unbounded intervals has not been implemented in this version')
        else
            g.vals(1) = 0;
            if abs(gtmp.vals(1)) > tol
                warning('FUN:cumsum:slowdecay','Representation is likely inaccurate')
            end
        end
        
    end
    
    % ---------------------------------------------------------------------
    
    % clean up rounding errors in exponential decay
    if isinf(ends(1)) && norm(g.vals(1:3),inf) < tol
        g.vals(abs(g.vals) < max(10*abs(vends(1)),10*eps*g.scl.v)) = 0;
    end
    if isinf(ends(2)) && norm(g.vals(end-2:end),inf) < tol
        g.vals(abs(g.vals) < max(10*abs(vends(2)),10*eps*g.scl.v)) = 0;
    end
    
    % Chain rule and extrapolate
    g.vals = g.vals.*g.map.der(y);
    g = extrapolate(g,pref,y);
    g = cumsum_unit_interval(g);    

% General map case
else
    
    map = g.map;
    if any(g.exps)
        warning('FUN:cumsum:dblexp',['Cumsum does not fully support functions ', ...
            'with both maps and exponents. Switching to a linear map (which may be VERY slow!)']);
        pref = chebfunpref;
        pref.splitting = false;
        pref.resampling = false;
        pref.blowup = false;
        % make the map linear
        exps = g.exps; g.exps = [0 0];
        g = fun(@(x) feval(g,x),linear(g.map.par(1:2)),pref);
        g.exps = exps;
        % do cumsum in linear case
        g = cumsum(g);
        % change the map back
        exps = g.exps; g.exps = [0 0];
        g = fun(@(x) feval(g,x),map,pref);
        g.exps = exps;
    else
        g.map = linear([-1 1]);
        g = cumsum_unit_interval(g.*fun(map.der,g.map));
        g.map = map;
    end
    
end

end

function g = cumsum_unit_interval(g)

    n = g.n;
    c = [0;0;chebpoly(g)];                        % obtain Cheb coeffs {c_r}
    cout = zeros(n-1,1);                          % initialize vector {C_r}
    cout(1:n-1) = (c(3:end-1)-c(1:end-3))./...    % compute C_(n+1) ... C_2
        (2*(n:-1:2)');
    cout(n,1) = c(end) - c(end-2)/2;              % compute C_1
    v = ones(1,n); v(end-1:-2:1) = -1;
    cout(n+1,1) = v*cout;                         % compute C_0
    g.vals = chebpolyval(cout);
    g.scl.v = max(g.scl.v, norm(g.vals,inf));
    g.n = n+1;
    
end

function [f G] = jacsum(f)
% for testing - delete this eventually
% h = f; h.exps = [0 0];

% Get the exponents
ends = f.map.par(1:2);
exps = f.exps;
a = exps(2); b = exps(1);

% Compute Jacobi coefficients of F
j = jacpoly(f,a,b).';

if abs(j(end)) < chebfunpref('eps'), j(end) = 0; end

% Integrate the nonconstant terms exactly to get new coefficients
k = (length(j)-1:-1:1).';
jhat = -.5*j(1:end-1)./k;

% Convert back to Chebyshev series
c = jac2cheb2(a+1,b+1,jhat);

% Construct fun
f.vals = chebpolyval(c);
f.n = length(f.vals);
f.exps = f.exps + 1;
f = f*diff(ends)/2;
f.scl.v = max(f.scl.v, norm(f.vals,inf));

% Deal with the constant part
if j(end) == 0
    G = 0;
elseif exps(2)
    const = j(end)*2^(a+b+1)*beta(b+1,a+1)*(diff(ends)/2);
    
    % Choose the right sing map
    mappar = [b a];
    mappar(mappar<=0) = mappar(mappar<=0)+1; 
    mappar(mappar>1) = mappar(mappar>1)-floor(mappar(mappar>1)) ;
    map = maps(fun,{'sing',mappar},ends);

    pref = chebfunpref;
    if all(mappar), pref.exps = [mappar(1) 0]; mappar(1) = 1; end
    G = fun(@(x) const*betainc((x-ends(1))/diff(ends),b+1,a+1),map,pref,f.scl);
else
    G = fun(j(end)/(1+exps(1)),f.map.par(1:2));
    const = (2/diff(ends)).^exps(1);
    G = const*setexps(G,[exps(1)+1 0]);
    
end

% Add together smooth and singular terms
if nargout == 1 || ~exps(2)
    f = f + G;
end

f = replace_roots(f);

end

function cheb = jac2cheb2(a,b,jac)
N = length(jac)-1;

if ~N, cheb = jac; return, end

% Chebyshev-Gauss-Lobatto nodes
x = chebpts(N+1);

apb = a + b;

% Jacobi Vandermonde Matrix
P = zeros(N+1,N+1);
P(:,1) = 1;    
P(:,2) = 0.5*(2*(a+1)+(apb+2)*(x-1));    
for k = 2:N
    k2 = 2*k;
    k2apb = k2+apb;
    q1 =  k2*(k + apb)*(k2apb - 2);
    q2 = (k2apb - 1)*(a*a - b*b);
    q3 = (k2apb - 2)*(k2apb - 1)*k2apb;
    q4 =  2*(k + a - 1)*(k + b - 1)*k2apb;
    P(:,k+1) = ( (q2+q3*x).*P(:,k) - q4*P(:,k-1) ) / q1;
end

f = fun;
f.vals = P*flipud(jac(:)); f.n = length(f.vals);
cheb = chebpoly(f);

end



function [f g] = unbdnd(f)
% If only one output is asked for, f is the whole function
% For two outputs, f is the smooth part, and g contains the log singularity

if ~strcmpi(f.map.name,'linear')
    error('FUN:cumsum:exps','cumsum does not yet support exponents <= 1 with arbitrary maps.');
end

error('CHEBFUN:fun:cumsum:unbdnd:fail','@FUN/CUMSUM is broken for functions which blowup');

flip = false;

exps = f.exps;

oldends = f.map.par(1:2);

if exps(2)~=0
    if ~exps(1)
        % Flip so singularity is on the left
        f.vals = f.vals(end:-1:1);
        exps = exps([2 1]);
        f.exps = exps;
        flip = true;
    else
        error('FUN:cumsum:both',['cumsum does not yet support functions whose ', ...
            'definite integral diverges and has exponents at both boundaries.']);
    end
end

% Shift domain to origin
f = newdomain(f,oldends-oldends(1));
ends = f.map.par(1:2);

f.exps = [0 0];
d = domain(ends);
x = fun('x',ends);
a = -exps(1);                             % The order of the pole

ra = round(a);
if ra == a
    ck = feval(diff(f,a-1),0)/factorial(a-1);     % Coefficient of x^(a-1) in Taylor 
                                                  % series about x = 0 (leads to log)                                    
    if abs(ck) > 1e-10
        xa1 = x; xa1.vals = chebpts(a,d).^(a-1); 
        xa1.n = a;                                % =  % x^(a-1)                                          
        p = f - ck*xa1;                           % Remove log contribution
    else 
        ck = 0;
        p = f;
    end
else
    ck = 0;
    p = f;
end

% feval(diff(p,a-1),0)/factorial(a-1)       % This should be zero now?

xp = x.*p;                      
N = length(xp);

% % Backslash
% D = diff(d); D = D(N); L = diag(get(xp,'points'))*D-diag(a*ones(N,1));
% % D = diff(d); L = diag(chebfun(x,ends))*D-a*eye(domain(ends)); L = L(N);
% if N > 1
%     L(1,:) = []; L(:,1) = [];
% end
% % What is the correct boundary condition??
% if N > 3,
%     L(end,:) = []; L(:,end) = [];
%     f = fun([0 ; L \ xp.vals(2:end-1) ; 0], ends);
% %     L(end,:) = 0;  L(end,end) = 1;  xp.vals(end) = 0;
% %     f = fun([0 ; L \ xp.vals(2:end)], ends);
% %     L(1,:) = D(1,2:end);     xp.vals(2) = 0;
% %     f = fun([0 ; L \ xp.vals(2:end)], ends);
% %     L(end,:) = D(end,2:end);     xp.vals(end) = 0;
% %     f = fun([0 ; L \ xp.vals(2:end)], ends);
% else
%     f = fun([0 ; L \ xp.vals(2:end)], ends);
% end
% f.exps = [-a 0];

% GMRES
D = diff(d); D = D(N); L = diag(get(xp,'points'))*D-diag(a*ones(N,1));
% D = diff(d); I = eye(d); L = diag(chebfun(x,ends))*D-a*eye(d); L = L(N);
[vals flag] = gmres(L,xp.vals,N,1e-15);
f = fun(vals,ends);
f.exps = exps;

% Bump the exponent by one
% f = extract_roots(f,1,[1 0]);

% Shft back to old domain
f = newdomain(f,oldends);

% Adding in the log term
g = fun;
if abs(ck) > 1e-13 % some kind of scale needed here
    if a == 1, a = 2; end
    if a == 2, map = maps(fun,{'sing',[.125 1]},oldends);
    else       map = maps(fun,{'sing',[.25 1]},oldends); end
    pref = chebfunpref; pref.extrapolate = 1;
    g = fun(@(x) ck*(x-oldends(1)).^(a-1).*log(x-oldends(1)),map,pref,f.scl);
    g = (2./diff(ends)).^exps(1)*setexps(g,[1-a 0]);
    if nargout == 1
        f = f+g;
    end 
else
    g = fun(0,oldends);
end

fr = get(f,'rval');
if abs(fr) > 1e-13
    f = f - fun(fr,f.map);
end

f = replace_roots(f);

if flip % Flip back so singularity is on the right
    f.vals = -f.vals(end:-1:1);
    f.exps = f.exps([2 1]);
    if strcmp(f.map.name,'sing')
        pars = f.map.par;
        f.map = maps(fun,{'sing',pars([4 3])},pars(1:2));
    end
    
    if nargout == 2 && ~isempty(g)
        g.vals = -g.vals(end:-1:1);
        g.exps = g.exps([2 1]);
        if strcmp(g.map.name,'sing')
            pars = g.map.par;
            g.map = maps(fun,{'sing',pars([4 3])},pars(1:2));
        end
    end
        
end

end


