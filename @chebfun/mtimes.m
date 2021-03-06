function Fout = mtimes(F1,F2)
% *   Chebfun multiplication.
%
% c*F or F*c multiplies a chebfun F by a scalar c.
%
% F*G, if F is an m-by-Inf row chebfun and G is an Inf-by-n column chebfun, 
% returns the m-by-n matrix of pairwise inner products. F and G must have
% the same domain.
%
% A = F*G, if F is Inf-by-m and G is m-by-Inf constructs a
% chebfun2 H of rank m such that
%
%  H(x,y) = F(y,1)*G(x,1) + ... + F(y,m)*G(x,m).
%
% See KRON for the linop representing the Fredholm operator with kernel 
% H(x,y).
%
% See also KRON. 

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Quasi-matrices product
if (isa(F1,'chebfun') && isa(F2,'chebfun'))
    if size(F1,2) ~= size(F2,1)
        error('CHEBFUN:mtimes:quasi','Quasimatrix dimensions must agree.')
    end
    if isinf(size(F1,1))     % outer product
        % OuterProduct so form a chebfun2:
        Fout = kron(F1,F2);   % Kronecker product

    else      % inner product
    
      funreturn = F1(1).funreturn || F2(1).funreturn;
      if funreturn
          Fout = chebconst;
      else
          Fout = zeros(size(F1,1),size(F2,2));
      end
      
      % Check for exponents
      hasexps = false;
      for k=1:numel(F1), f = F1(k); for j=1:f.nfuns
        hasexps = hasexps || any( f.funs(j).exps ~= 0 );
      end; end
      for k=1:numel(F2), f = F2(k); for j=1:f.nfuns
          hasexps = hasexps || any( f.funs(j).exps ~= 0 );
      end; end
        
      % Check for non-linear maps
      nonlinmap = false;
      for k=1:numel(F1), f = F1(k); for j=1:f.nfuns
        nonlinmap = nonlinmap || ~strcmp( f.funs(j).map.name , 'linear' );
      end; end
      for k=1:numel(F2), f = F2(k); for j=1:f.nfuns
        nonlinmap = nonlinmap || ~strcmp( f.funs(j).map.name , 'linear' );
      end; end

      % Check for delta functions
      n = numel(F1);
      hasdeltasF1 = zeros(1,n);
      for k = 1:n 
          f = F1(k);
          if(size(f.imps,1)>=2)
              hasdeltasF1(k) = true;
           end
      end
      n = numel(F2);
      hasdeltasF2 = zeros(1,n);
      for k = 1:n
          f = F2(k);
          if(size(f.imps,1)>=2)
              hasdeltasF2(k) = true;
          end
      end
      hasdeltas = any(hasdeltasF1) | any(hasdeltasF2);
          

      % If the quasimatrices F1 and F2 have neither exponents nor non-linear
      % maps, then we can compute a discretized inner product. This is done
      % by discretizing both F1 and F2 on a chebyshev grid of the size of
      % the sum of their lengths and computing the inner products relative
      % to the Clensaw-Curtis quadrature weights.
      if ~hasexps && ~nonlinmap && ~hasdeltas
      
        % Get the outer dimensions
        m = size(F1,1); n = size(F2,2);
      
        % Get the set of breakpoints for all funs in F1 and F2
        ends = [];
        for k=1:m, ends = union( ends , F1(k).ends ); end
        for k=1:n, ends = union( ends , F2(k).ends ); end
        %iends = ends(2:end-1)';
        nfuns = length(ends) - 1;
        
        % Get the sizes in F1 and F2
        sizes1 = zeros( nfuns , m );
        for k=1:m
            f = F1(k); ef = f.ends;
            for j=1:nfuns
                sizes1(j,k) = f.funs( find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1 ).n;
            end
        end
        sizes1 = max( sizes1 , [] , 2 );
        sizes2 = zeros( nfuns , n );
        for k=1:n
            f = F2(k); ef = f.ends;
            for j=1:nfuns
                sizes2(j,k) = f.funs( find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1 ).n;
            end
        end
        sizes2 = max( sizes2 , [] , 2 );
        
        % Get the product sizes.
        sizes = sizes1 + sizes2;
        inds = [ 0 ; cumsum(sizes) ];
        
        % Create the chebyshev nodes and quadrature weights
        [ pts , w ] = chebpts( sizes , ends );

        % Discretize F1 and F2. Do this fun-wise to get the right values
        % at the edges of the funs if there are jumps.
        dF1 = zeros( sum(sizes) , m );
        if nfuns > 1
            for k=1:m
                f = F1(k); ef = f.ends;
                for j=1:nfuns
                    ind = find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1;
                    dF1( inds(j)+1:inds(j+1) , k ) = feval( f.funs(ind) , pts( inds(j)+1:inds(j+1) ) );
                end
            end
        else
            for k=1:m
                dF1( : , k ) = chebpolyval( [ zeros( sizes(j) - F1(k).funs.n , 1 ) ; F1(k).funs(1).coeffs ] );
            end
        end
        dF2 = zeros( sum(sizes) , n );
        if nfuns > 1
            for k=1:n
                f = F2(k); ef = f.ends;
                for j=1:nfuns
                    ind = find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1;
                    dF2( inds(j)+1:inds(j+1) , k ) = feval( f.funs(ind) , pts( inds(j)+1:inds(j+1) ) );
                end
            end
        else
            for k=1:n
                dF2( : , k ) = chebpolyval( [ zeros( sizes(j) - F2(k).funs.n , 1 ) ; F2(k).funs.coeffs ] );
            end
        end
        
        % Form the inner products
        Fout = dF1.' * spdiags(w',0,inds(end),inds(end)) * dF2;
        
      % Otherwise, same old...
      else
          for k = 1:size(F1,1)
            for j = 1:size(F2,2)
              if F1(k).trans && ~F2(j).trans
                if(hasdeltasF1(k) && hasdeltasF2(j))
                    [f1,f2] = overlap(F1(k).',F2(j));
                    % mulitply the impulses pointwise
                    imps = f1.imps.*f2.imps;
                    idx = abs(imps)>100*eps;
                    if(any(any(idx)))
                        % signed infinity where impulses match
                        imps(idx) = inf*imps(idx);
                        % add infinities along rows then columns
                        s = sum(sum(imps,2),1);  
                        % s can be Inf or NaN
                        if(isinf(s) || isnan(s))
                            Fout(k,j) = s;
                        % otherwise s is zero
                        else
                            Fout(k,j) = sum((F1(k).').*F2(j));
                        end
                    else
                        % There should be no impulses at this point
                        F1(k).imps = F1(k).imps(1,:); F2(k).imps = F2(k).imps(1,:);
                        Fout(k,j) = sum((F1(k).').*F2(j));
                    end
                    
                else                 
                    Fout(k,j) = sum((F1(k).').*F2(j));
                end
              else
                error('CHEBFUN:mtimes:dim','Chebfun dimensions must agree.')
              end
            end
          end
          
      end 
      
    % Ensure f'*f has no complex compnent  
    ID1 = get(F1,'ID'); ID2 = get(F2,'ID'); 
    if iscell(ID1), ID1 = reshape([ID1{:}],2,numel(F1)); end
    if iscell(ID2), ID2 = reshape([ID2{:}],2,numel(F2)); end
    mask = bsxfun(@eq,ID1(:,1),ID2(:,1)) & bsxfun(@eq,ID1(:,2),ID2(:,2));
    Fout(mask) = real(Fout(mask));
        
    end

% Chebfun times double
elseif isa(F1,'chebfun')
    
    if ~isnumeric(F2)
        error('CHEBFUN:mtimes:chebfunlinop',...
            ['Chebfun-' class(F2) ' multiplication is not well-defined.']);
    end
    
    % scalar times chebfun
    if numel(F2) == 1
        Fout = F1;
        for k = 1:numel(F1)
            Fout(k) = mtimescol(F2,F1(k));
        end
     % quasimatrix times matrix of doubles
    else
    
        % Check the inner size.
        if size(F1,2)~=size(F2,1), error('CHEBFUN:mtimes:dim','Dimensions must agree'), end
        
        % Check for exponents
        hasexps = false;
        for k=1:numel(F1), 
            f = F1(k); 
            for j=1:f.nfuns
                hasexps = hasexps || any( f.funs(j).exps ~= 0 );
            end
        end

        % Check for non-linear maps
        nonlinmap = false;
        for k=1:numel(F1), 
            f = F1(k); 
            for j=1:f.nfuns
                nonlinmap = nonlinmap || ~strcmp( f.funs(j).map.name , 'linear' );
            end
        end

        % If the quasimatrix F1 has neither exponents nor non-linear maps,
        % it is discretized over a grid of Chebyshev nodes of the length
        % of the largest column. The column sums are then formed over the
        % discretized columns and reassembled as Chebfuns.
        if ~hasexps && ~nonlinmap
        
            % Get a hand on some useful values
            n = size(F1,2);
        
            % Get the set of breakpoints for all funs in F1
            ends = [];
            for k=1:n, ends = union( ends , F1(k).ends ); end
            ends = ends(:).';
            %iends = ends(2:end-1)';
            m = length(ends)-1;
            
            % Discretize all columns of F1
            sizes = zeros( m , n );
            for k=1:n
                f = F1(k); ef = f.ends;
                for j=1:m
                    sizes(j,k) = f.funs( find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1 ).n;
                end
            end
            sizes = max( sizes , [] , 2 ); inds = [ 0 ; cumsum(sizes) ];
            dF = zeros( sum(sizes) , n );
            if m > 1
                for k=1:n
                    f = F1(k); ef = f.ends;
                    for j=1:m
                        ind = find( ef > (ends(j)+ends(j+1))/2 , 1 ) - 1;
                        dF( inds(j)+1:inds(j+1) , k ) = feval( f.funs(ind) , chebpts( sizes(j) , ends(j:j+1) ) );
                    end
                end
            else
                for k=1:n
                    if F1(k).funs.n == sizes(1)
                        dF( : , k ) = F1(k).funs.vals;
                    else
                        dF( : , k ) = chebpolyval( [ zeros( sizes(1) - F1(k).funs.n , 1 ) ; F1(k).funs.coeffs ] );
                    end
                end
            end
            
            % Sum the columns
            res = dF * F2;
            
            % Re-assemble the chebfun(s)
            for k=1:size(res,2)
                g = chebfun;
                g.nfuns = m;
                g.ends = ends;
                g.scl = norm( res( : , k ) , inf );
                g.imps = res( [ 1 ; inds(2:end) ] , k )';
                f = {};
                for j=1:m
                    f{end+1} = { res( inds(j)+1:inds(j+1) , k ) , ends(j:j+1) };
                    g.imps(j+1) = res(inds(j+1),k);
                end
                g.funs = simplify( fun( f ) );
                % g.jacobian = anon( '[dF,nonConst]=diff(F,u,''linop''); der=dF*x;' , {'x','F'} , { F2(k) , F1 } , 1 , 'mtimes' );
                Fout(k) = g;
            end
        
        % Otherwise, don't use new features.
        else
            
            % Straight-forward scaling and addition of chebfuns.
            for j = 1:size(F2,2)
                Fout(j) =  mtimescol(F2(1,j),F1(1));
                for i = 2:size(F2,1)
                    Fout(j) = Fout(j) + mtimescol(F2(i,j),F1(i));
                end
            end
            
        end
    end
else
    Fout = mtimes(F2.',F1.').';
end

end

% ------------------------------------
function f = mtimescol(a,f)
a = full(a);
f.funs = a*f.funs;
f.imps = a*f.imps;
f.scl = abs(a)*f.scl;

if a==0
    % Make sure to create a zero linop of a correct blocksize by using
    % repmat, similarly, ensure nonConst is of correct size using zeros.
    f.jacobian = anon('der = repmat(zeros(domain(f)),1,numel(u)); nonConst = zeros(1,numel(u));',{'f'},{f},1,'mtimes');
else
    an = anon('[tempDer nonConst] = diff(f,u,''linop''); der = a*tempDer;',{'a' 'f'},{a f},1,'mtimes');
    f.jacobian = an;
end
f.ID = newIDnum;
end
