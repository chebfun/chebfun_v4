function f = extract_roots(f)

% Get the domain
d = f.map.par(1:2);
% Get the exponents
exps = get(f,'exps');
% Get the map
map = f.map;

if ~strcmp(map.name,'linear')
    error('CHEBFUN:extract_roots:linear', ...
        'Extract roots currently only works for a linear map!'); 
end

% Tolerance for a root
tol = 1000*chebfunpref('eps')*f.scl.v;

f.exps = [0 0];
f0 = abs(feval(f,d));

if all(f0 > tol),
    return
end

% The chebyshev coefficients of f
c = chebpoly(f);

while any(f0 < tol) && f.n >1
    
    c = flipud(c);

    if f0(1) < tol
        % left
        a = d(1);   
        sgn = 1;   
        exps(1) = exps(1) + 1;
    else
        % right
        a = d(2);
        sgn = -1;
        exps(2) = exps(2) + 1;
    end

    % Construct the matrix for the recurrence
    n = length(c);
    e = .5*ones(n-1,1);
    D = spdiags([e sgn*2*e e], 0:2, n-1, n-1); 
    D(1,1) = 1;

    % The new coefficients
    c = sgn*flipud(D\c(2:end))*(2./diff(d));

    % Construct new f
    f = fun(chebpolyval(c),d);
    f.map = map;
    f0 = abs(feval(f,d));
    f.exps = exps;

end

