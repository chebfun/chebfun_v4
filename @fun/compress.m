function uout = compress(uin)
% Attempt to compress a fun using slitmaps.
% This was put here by NicH and is just for RodP to play with.
%
% See @chebfun/compress

% tolerance
tol = chebfunpref('eps')*1000;

% Max degree of enominator
maxnpoles = 10;

% Chebfun with linear map
uout = simplify(uin,tol);
map.for = @(x) x;
map.der = @(x) 1+0*x;
map.name = 'linear';
map.par = [-1 1];

% Chebyshev coefficients
c = chebpoly(uin);
m = find(abs(c(end:-1:1))/max(abs(c))>1e-6,1,'last');

% Chebpade only operations on chebfuns. Need to fix this.
uinc = chebfun(uin,'splitting',false);   
x = chebpts(uin.n);

j = 0;
for npoles = 2:2:maxnpoles  % increase degree of denominator
    j = j + 1;
    
    % choose numerator length
    m = min(round(m),length(uin)-2*npoles);
    
    % Chebyshev-Pade approximation to find poles
    [r p q] = chebpade(uinc,m,npoles);
    poles = roots(q,'all');
    
    poles(abs(imag(poles))<1e-4) = [];

    if ~isempty(poles)
        % compute the slitmap
        [g gp] = slitmap(poles(1:2:end));
        u = simplify(fun(feval(uin,g(x)),[-1,1]),tol);
        chebpolyplot(chebfun(u)); hold on
        if length(u) < uout.n
            uout = u;
            map.for = g;
            map.der = gp;
            map.par = [-1 1];
            map.name = ['slitmap',sum(abs(poles))];
            disp(['Choosing ',int2str(npoles),' poles.']);
        end
    end
end
uout.map = map;