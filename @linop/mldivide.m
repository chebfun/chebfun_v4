function C = mldivide(A,B,tolerance)
% \  Solve a linear operator equation.
% U = A\F solves the linear system A*U=F, where U and F are chebfuns and A
% is a linop. If A is a differential operator of order M, a warning will
% be issued if A does not have M boundary conditions. In general the
% function may not converge in this situation.
%
% The algorithm is to realize and solve finite linear systems of increasing
% size until the chebfun constructor is satisfied with the convergence.
% This convergence is in a relative sense for U, which may not be
% appropriate in some situations (e.g., Newton's method finding a small
% correction). To set a different scale S for the relative accuracy, use
% A.scale = S before solving.
%
% EXAMPLE
%   % Newton's method for (u')^2+6u=1, u(0)=0.
%   d = domain(0,1);  D = diff(d);
%   f = @(u) diff(u).^2 - 6*u - 1;
%   J = @(u) (diag(2*diff(u))*D - 6) & 'dirichlet';
%   u = chebfun('x',d);  du = Inf;
%   while norm(du) > 1e-12
%     r = f(u);  A = J(u);  A.scale = norm(u);
%     du = -(A\r);
%     u = u+du;
%   end

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

 maxdegree = cheboppref('maxdegree');

 switch(class(B))
  case 'linop'
    %TODO : Experimental, undocumented.
    dom = domaincheck(A,B);
    C = linop( A.varmat\B.varmat, [], dom, B.difforder-A.difforder );  

  case 'double'
    if length(B)==1  % scalar expansion
      C = mldivide(A,chebfun(B,domain(A),chebopdefaults));
    else
      error('LINOP:mldivide:operand','Use scalar or chebfun with backslash.')
    end

  case 'chebfun'
    dom = domaincheck(A,B(:,1));
    m = A.blocksize(2);
    if A.numbc ~= sum(max(A.difforder,[],2))    
      warning('LINOP:mldivide:bcnum',...
        'Operator may not have the correct number of boundary conditions.')
    end
    
    % Grab the default settings.
    settings = chebopdefaults;
    if nargin == 3
        settings.eps = tolerance;
    end

    % Take the union of all the ends.
    ends = dom.endsandbreaks;
    for k = 1:numel(B)
        ends = union(B(:,k).ends,ends);
    end

    % Deal with maps.
    % TODO : test this.
    map = mapcheck(get(B(:,1),'map'),get(B(:,1),'ends'),1);
    if ~isempty(map)
        settings.map = map;
    end   
    
    % Can't do this yet. 
    if ~isempty(map) && numel(map)~=numel(ends)-1
        warning('CHEBFUN:linop:mldivide:mapbreaks',...
            'New breakpoint introduced, so map data from RHS is ignored.');
        map = [];
    end
    
    V = [];  % Initialise V so that the nested function overwrites it.
    syssize = A.blocksize(1);     % Number of eqns in system.
    coef = [1, 2 + sin(1:syssize-1)];  % for a linear combination of variables
    
    % Enforce required conditions on an unbounded integro-equation
    infdom = isinf(isinf(ends));
    if syssize == 1 && A.difforder == -1 && (any(infdom) || (isempty(A.lbc) && isempty(A.rbc)))
        bc = struct('left',struct([]),'right',struct([]));
        I = eye(domain(ends));
        if infdom(end)
            bc.right = struct('op',I,'val',0);
            if infdom(1)
                bc.left = struct('op',I,'val',0);
            end
        else
            bc.left = struct('op',I,'val',0);
        end
        A = setbc(A,bc);
    end

    if isa(A.scale,'function_handle')
        A.scale = chebfun(A.scale,ends);
    end
    if isa(A.scale,'chebfun')
        warning('CHEBFUN:linop:mldivide:sclfun', ...
            'No support for function scaling for piecewise domains.')
        C = chebfun( @(x,N,bks) A.scale(x) + value(x,N,bks), ...
            {ends}, settings) - A.scale;
    else 
        settings.scale = A.scale;
        C = chebfun( @(x,N,bks) value(x,N,bks), {ends}, settings);
    end
    
    % If there aren't systems, then we're done.
    if m == 1, C = C{:}; return, end

    % V has been overwritten by the nested value function.
    % We need to simplify it and store as the output.
    C = chebfun; % Will contain the output.
    for j = 1:m  % For each variable, build a chebfun.
        tmp = chebfun;          % Temporary chebfun for the jth variable.
        for k = 1:numel(ends)-1 % Loop over each subinterval.
            funk = fun( V{1}, ends(k:k+1), settings);
            tmp = [tmp ; set(chebfun,'funs',funk,'ends',ends(k:k+1),...
                'imps',[funk.vals(1) funk.vals(end)],'trans',0)];
            V(1) = [];
        end
        C(:,j) = simplify(tmp,settings.eps); % Simplify and store.
    end
    
  otherwise
    error('LINOP:mldivide:operand','Unrecognized operand.')
    
 end

 function v = value(y,N,bks)
    % y is a cell array with the points for each function.
    % N is the number of points on each subinterval.
    % bks contains the ends of the subintervals.

    N = N{:};   bks = bks{:};     % We allow only the same discretization.
                                  % Size and breaks for each system.
    maxdo = max(A.difforder(:));  % Maximum derivative order of the system.
                                    
    if sum(N) > maxdegree+1
      error('LINOP:mldivide:NoConverge',...
          ['Failed to converge with ',int2str(maxdegree+1),' points.'])
    elseif any(N==1)
      error('LINOP:mldivide:OnePoint',...
        'Solution requested at a lone point. Check for a bug in the linop definition.')
    elseif any(N < maxdo+1)
      % Too few points: force refinement.
      jj = find(N < maxdo+1);
      csN = [0 ; cumsum(N)];
      v = y;
      for kk = 1:length(jj)
          e = ones(N(jj(kk)),1); e(2:2:end) = -1;
          v{csN(jj(kk))+(1:N(jj(kk)))} = e; 
      end
      return
    end    

    % Evaluate the matrix with boundary conditions attached.
    [Amat,ignored,c,ignored,P] = feval(A,N,'bc',map,bks);

    % Project the RHS
    if syssize == 1
        if any(isinf(B.ends))
            f = P*B(y{1},1);
        else
            f = B(P*y{1},1);
        end
    else
        f = [];
        if any(isinf(B(:,1).ends))
            for jj = 1:syssize, f = [f ; P{jj}*B(y{1},jj)]; end
        else
            for jj = 1:syssize, f = [f ; B(P{jj}*y{1},jj)]; end
        end
    end
    f = [f ; c];                            % Add boundary conditions.

    v = Amat\f;                             % Solve the system.
    V = mat2cell(v,repmat(N,1,syssize),1);  % Store for output.
    v = reshape(v,[sum(N),syssize]);        % one variable per column
    % Need to return a single function to test happiness. If you just sum
    % functions, you get weird results if v(:,1)=-v(:,2), as can happen in
    % very basic problems. We just use an arbitrary linear combination (but
    % the same one each time!). 
    v = v*coef(:); 
    
    % Filter
    csN = cumsum([0 N]);
    for jj = 1:numel(N)
        ii = csN(jj) + (1:N(jj));
        v(ii) = filter(v(ii),1e-8);
    end
    
    v = {v};                                % Output as cell array.
    
  end

end





%%%%%%%%%%%%%%%%%% JUNK %%%%%%%%%%%%%%%%%%%%

% For future performance, store LU factors of realized matrices.
% persistent storage
% if isempty(storage), storage = struct([]); end
% use_store = cheboppref('storage');

% dorectmat = 1;
    
%     % Call the constructor 
%     if numel(ends) == 2 && ~chebfunpref('splitting') && ~dorectmat
%     % Smooth and non-systems
%         if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
%           C = chebfun( @(x) A.scale(x)+value_old(x), ends, settings) - A.scale;
%         else
%           settings.scale = A.scale;
%           C = chebfun( @(x) value_old(x), ends, settings);
%         end
%     else
%     % Piecewise and/or systems
%         if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
%             warning('CHEBFUN:linop:mldivide:sclfun', ...
%                 'No support for function scaling for piecewise domains.')
%             if isa(A.scale,'function_handle'), A.scale = 1;
%             else A.scale = norm(A.scale,inf); end
%         end
%         settings.scale = A.scale;
%         C = chebfun( @(x,N,bks) value(x,N,bks), {ends}, settings);
%         if m == 1, C = C{:}; end
%     end


%   function v = value_old(x)
%     N = length(x);
%     if N > maxdegree+1
%       error('LINOP:mldivide:NoConverge',['Failed to converge with %i points.',maxdegree+1])
%     elseif N==1
%       error('LINOP:mldivide:OnePoint',...
%         'Solution requested at a lone point. Check for a bug in the linop definition.')
%     elseif N <= A.numbc+1 || N < 2
%       % Too few points: force refinement
%       v = ones(N,1); 
%       v(2:2:end) = -1;
%       return
%     end
%     A.difforder = abs(A.difforder);
%     x1 = [];
%     
%     % We don't store matrices if there are maps.
%     if ~isempty(map), use_store = 0; end
%     
%     % Retrieve or compute LU factors of the matrix.
%     if use_store && N > 5 && length(storage)>=A.ID ...
%         && length(storage(A.ID).L)>=N && ~isempty(storage(A.ID).L{N})
%       L = storage(A.ID).L{N};
%       U = storage(A.ID).U{N};
%       x1 = storage(A.ID).x1{N};
%       c = storage(A.ID).c{N};
%       rowidx = storage(A.ID).rowidx{N};
%     else  % have to compute L and U
%       Amat = feval(A,N,map,ends);
%       
%       if dorectmat && m == 1% New rectangular matrix method
%         [Bmat,c] = bdyreplace(A,{N},map,{ends}); rowidx = [];
%         if any(isinf(ends))
%             % We don't want chebpts to do the scaling in this case. (Done below).
%             x1 = chebpts(N-A.numbc,[-1 1],1);            
%         else
%             x1 = chebpts(N-A.numbc,ends,1);
%         end
%         if ~isempty(map) % Map the 1st-kind points. (x is already mapped).
%             if isstruct(map)
%                 x1 = map.for(x1);
%             else
%                 x1 = map(x1);
%             end
%         end
%         Amat = [barymat(x1,x)*Amat; Bmat];
%       else                   % Do things the old way
%         [Bmat,c,rowidx] = bdyreplace_old(A,N,map,ends);
%         Amat(rowidx,:) = Bmat;
%       end
%       
%       [L,U] = lu(Amat);
%       if use_store && N > 5   % store L and U
%         % Very crude garbage collection! If over capacity, clear out
%         % everything.
%         ssize = whos('storage');
%         if ssize.bytes > cheboppref('maxstorage')
%           storage = struct([]);
%         end
%         storage(A.ID).L{N} = L;
%         storage(A.ID).U{N} = U;
%         storage(A.ID).x1{N} = x1;
%         storage(A.ID).c{N} = c;
%         storage(A.ID).rowidx{N} = rowidx;
%       end        
%     end
%     
%     % Evaluate and modify RHS as needed.
%     if m == 1 && dorectmat
%         f = B(x1,:);
%         f = [f ; c]; 
%     else
%         f = B(x,:);
%         f = f(:);
%         f(rowidx) = c;
%     end
% 
%     % Solve.
%     v = U\(L\f);
% 
%     V = reshape(v,N,m);
%     v = sum(V,2);
%     v = filter(v,1e-8);
% 
%   end