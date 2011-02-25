function V = volt(k,d,onevar)
% VOLT  Volterra integral operator.
% V = VOLT(K,D) constructs a chebop representing the Volterra integral
% operator with kernel K for functions in domain D=[a,b]:
%    
%      (V*v)(x) = int( K(x,y) v(y), y=a..x )
%  
% The kernel function K(x,y) should be smooth for best results.
%
% K must be defined as a function of two inputs X and Y. These may be
% scalar and vector, or they may be matrices defined by NDGRID to represent
% a tensor product of points in DxD. 
%
% VOLT(K,D,'onevar') will avoid calling K with tensor product matrices X 
% and Y. Instead, the kernel function K should interpret a call K(x) as 
% a vector x defining the tensor product grid. This format allows a 
% separable or sparse representation for increased efficiency in
% some cases.
%
% Example:
%
% To solve u(x) + x*int(exp(x-y)*u(y),y=0..x) = f(x):
% [d,x] = domain(0,2);
% V = volt(@(x,y) exp(x-y),d);  
% u = (1+diag(x)*V) \ sin(exp(3*x)); 
%
% See also fred, chebop.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

C = cumsum(d);
V = linop(@matrix,@op,d,-1);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(z)
    % Result can be resolved relative to norm(u). (For instance, if the
    % kernel is nearly zero by cancellation on the interval, don't try to
    % resolve it relative to its own scale.) 
    opt = {'resampling',false,'splitting',true,'blowup','off'};
    % Return a chebfun for integrand at any x
    dom = domain(z);  brk = dom.ends(2:end-1); 
    nrm = norm(z);
    h = @(x) chebfun(@(y) z(y).*k(x,y),[dom.ends(1) brk(brk<x) x], ...
        opt{:},'scale',nrm,'exps',[0 0]);    
    v = chebfun(@(x) sum(h(x)), [d.ends(1) brk d.ends(2)], ...
        'exps',[0 0],'vectorize','scale',nrm);
    newjac =  anon('[Jzu nonConstJzu] = diff(z,u); der = V*diff(z,u); nonConst = nonConstJzu | (~V.iszero & ~Jzu.iszero);',{'V','z'},{V,z},1);
    v = jacreset(v,newjac);
  end

% Matrix form. Each row of the result, when taken as an inner product with
% function values, does the proper quadrature. Note that while C(n) would
% be triangular for low-order quadrature, for spectral methods it is not.
if nargin==2, onevar=false; end
  function A = matrix(n)
    breaks = []; map = [];
    if iscell(n)
        if numel(n) > 1, map = n{2}; end
        if numel(n) > 2, breaks = n{3}; end
        n = n{1};
    end
    
    % Force a default map for unbounded domains.
    if any(isinf(d)) && isempty(map), map = maps(d); end
    % Inherit the breakpoints from the domain.
    breaks = union(breaks, d.ends);
    if isa(breaks,'domain'), breaks = breaks.ends; end
    if numel(breaks) == 2
        % Breaks are the same as the domain ends. Set to [] to simplify.
        breaks = [];
    elseif numel(breaks) > 2
        numints = numel(breaks)-1;
        if numel(n) == 1, n = repmat(n,1,numints); end
        if numel(n) ~= numints
            error('DOMAIN:volt:numints','Vector N does not match domain D.');
        end
    end
   
    if isempty(breaks) || isempty(map)
        % Not both maps and breaks
        if ~isempty(map)
            x = map.for(chebpts(n));
        else
            if isempty(breaks), breaks = d.ends; end
            x = chebpts(n,breaks);
        end
    else
        % Maps and breaks
        csn = [0 cumsum(n)];
        x = zeros(csn(end),1);
        if iscell(map) && numel(map) == 1, map = map{1}; end
        mp = map;
        for j = 1:numints
            if numel(map) > 1
                if iscell(map), mp = map{j}; end
                if isstruct(map), mp = map(j); end
            end
            ii = csn(j)+(1:n(j));
            x(ii) = mp.for(chebpts(n(j)));
        end
    end
    
    if onevar  
        A = k(x);
    else
        [X,Y] = ndgrid(x);
        A = k(X,Y);
    end
    A = A.*feval(C,n,0,map,breaks);
        
    
    
  end
    

end
