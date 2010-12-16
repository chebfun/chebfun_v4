function F = fred(k,d,onevar)
% FRED  Fredholm integral operator.
% F = FRED(K,D) constructs a chebop representing the Fredholm integral
% operator with kernel K for functions in domain D=[a,b]:
%    
%      (F*v)(x) = int( K(x,y)*v(y), y=a..b )
%  
% The kernel function K(x,y) should be smooth for best results.
%
% K must be defined as a function of two inputs X and Y. These may be
% scalar and vector, or they may be matrices defined by NDGRID to represent
% a tensor product of points in DxD. 
%
% FRED(K,D,'onevar') will avoid calling K with tensor product matrices X 
% and Y. Instead, the kernel function K should interpret a call K(x) as 
% a vector x defining the tensor product grid. This format allows a 
% separable or sparse representation for increased efficiency in
% some cases.
%
% Example:
%
% To solve u(x) - x*int(exp(x-y)*u(y),y=0..2) = f(x), in a way that 
% exploits exp(x-y)=exp(x)*exp(-y), first write:
%
%   function K = kernel(X,Y)
%   if nargin==1   % tensor product call
%     K = exp(x)*exp(-x');   % vector outer product
%   else  % normal call
%     K = exp(X-Y);
%   end
%
% At the prompt:
%
% [d,x] = domain(0,2);
% F = fred(@kernel,d);  % slow way
% tic, u = (1-diag(x)*F) \ sin(exp(3*x)); toc
%   %(Elapsed time is 0.265166 seconds.)
% F = fred(@kernel,d,'onevar');  % fast way
% tic, u = (1-diag(x)*F) \ sin(exp(3*x)); toc
%   %(Elapsed time is 0.205714 seconds.)
%
% See also volt, chebop.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by Toby Driscoll and Folkmar Bornemann.

%  Last commit: $Author$: $Rev$:
%  $Date$:

F = linop(@matrix,@op,d);

% Functional form. At each x, do an adaptive quadrature.
  function v = op(z)
    % Result can be resolved relative to norm(u). (For instance, if the
    % kernel is nearly zero by cancellation on the interval, don't try to
    % resolve it relative to its own scale.) 
    nrmf = norm(z);
    opt = {'resampling',false,'splitting',true,'exps',[0 0],'scale',nrmf};
    int = @(x) sum(z.* (chebfun(@(y) k(x,y),d,opt{:})));
    v = chebfun( int, d,'sampletest',false,'resampling',false,'exps',[0 0],'vectorize','scale',nrmf);
    newjac =  anon('[Jzu nonConstJzu] = diff(z,u); der = F*diff(z,u); nonConst = nonConstJzu | (~F.iszero & ~Jzu.iszero);',{'F','z'},{F,z},1);
    v = jacreset(v,newjac);
  end

% Matrix form. At given n, multiply function values by CC quadrature
% weights, then apply kernel as inner products. 
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
            error('DOMAIN:fred:numints','Vector N does not match domain D.');
        end
    end

    if isempty(breaks) || isempty(map)
        % Not both maps and breaks
        if ~isempty(map)
            [x s] = chebpts(n);
            s = map.der(x.').*s;
            x = map.for(x);
        else
            if isempty(breaks), breaks = d.ends; end
            [x s] = chebpts(n,breaks);
            n = sum(n);
        end
    else
        % Maps and breaks
        csn = [0 cumsum(n)];
        x = zeros(csn(end),1);
        s = zeros(1,csn(end));
        if iscell(map) && numel(map) == 1, map = map{1}; end
        mp = map;
        for j = 1:numints
            if numel(map) > 1
                if iscell(map), mp = map{j}; end
                if isstruct(map), mp = map(j); end
            end
            ii = csn(j)+(1:n(j));
            [xj sj] = chebpts(n(j));
            s(ii) = mp.der(xj.').*sj;
            x(ii) = mp.for(xj);
        end
        n = sum(n);
    end
    
    if onevar  % experimental
      A = k(x)*spdiags(s',0,n,n);
    else
      [X,Y] = ndgrid(x);
      A = k(X,Y) * spdiags(s',0,n,n);
    end

  end

end