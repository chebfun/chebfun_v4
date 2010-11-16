function C = syssolve(A,B,tolerance,ends)
% \  Solve a linear operator equation.
% U = A\F solves the linear system A*U=F, where U and F are chebfuns and A
% is a chebop. If A is a differential operator of order M, a warning will
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
%
% See also linop/and, linop/mtimes.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author: hale $: $Rev: 1174 $:
%  $Date: 2010-08-05 11:13:53 +0100 (Thu, 05 Aug 2010) $:

% For future performance, store LU factors of realized matrices.
persistent storage
if isempty(storage), storage = struct([]); end
use_store = cheboppref('storage');
maxdegree = cheboppref('maxdegree');

switch(class(B))
  case 'linop'
    %TODO: Experimental, undocumented.
    dom = domaincheck(A,B);
    C = linop( A.varmat\B.varmat, [], dom, B.difforder-A.difforder );  

  case 'double'
    if length(B)==1  % scalar expansion
      C = syssolve(A,chebfun(B,domain(A),chebopdefaults));
    else
      error('LINOP:mldivide:operand','Use scalar or chebfun with backslash.')
    end

  case 'chebfun'
    dom = domaincheck(A,B(:,1));
    m = A.blocksize(2);
    if (m==1) && (A.numbc~=A.difforder)
      warning('LINOP:mldivide:bcnum',...
        'Operator may not have the correct number of boundary conditions.')
    end
    settings = chebopdefaults;
    if nargin == 3 && ~isempty(tolerance)
        settings.eps = tolerance;
    end

    map = B(:,1).map;
    breaks = cell(m,1);
    for k = 1:numel(B)
        breaks{k} = B(:,k).ends;
    end
    
    if ~isempty(map)
        if     strcmp(map.name,'linear'), map = [];
        else   settings.map = map; end
    end   
    
    V = []; % so that the nested function overwrites it
%     if m > 1 || nargin > 3 || any(cellfun(@numel,breaks)>2)
        if nargin < 3, ends = breaks; end
        oldends = ends;
        % Take the union of the ends
%         ends = repmat({unique([ends{:}])},1,numel(ends)); % Is this right?
        C = chebfun( @(x) valuesys(x), ends, settings);
%         if m == 1, C = C{1}; end
%     else
%         if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
%           C = chebfun( @(x) A.scale(x)+value(x), dom, settings) - A.scale;
%         else
%           settings.scale = A.scale;
%           C = chebfun( @(x) value(x), dom, settings);
%         end
%     end
    
%     V has been overwritten by the nested value function.
    if m > 1
        l = 1;
        C = chebfun;
        settings.maxdegree = maxdegree;
        settings.maxlength = maxdegree;
        for j = 1:m
            tmp = chebfun;            
            for k = 1:numel(ends{j})-1
                funk = fun( V{l}, ends{j}(k:k+1), settings);
                tmp = [tmp ; set(chebfun,'funs',funk,'ends',ends{j}(k:k+1),...
                    'imps',[funk.vals(1) funk.vals(end)],'trans',0)];
                l = l+1;
            end
            % Merge introduced ends
            if length(tmp.ends)>2         
                tmp = merge(tmp,find(~ismember(ends{j},oldends{j})),settings); % Avoid merging at specified breakpoints
            end
            C(:,j) = simplify(tmp,10*settings.eps);
        end
    end
    
  otherwise
    error('LINOP:mldivide:operand','Unrecognized operand.')
end


  function v = valuesys(y)
    % y is a cell array with the points for each function.
    syssize = numel(y);                 % # of functions/eqns in system
    % Beakpoints for each function.
    [breaks brkidx] = cellfun(@findbreaks,y,'UniformOutput',false);  
    nfuns = numel([breaks{:}])-syssize; % # of funs (intervals) per function  
    
    Adifforder = A.difforder;
    
    % Nsys{j}(k) willl contain the # of pts for function j on interval k.
    Nsys = cell(syssize,1); 
    x = cell(1,nfuns); % x will be a cell of the points on each interval
    do = zeros(nfuns,1); % do(j) will be the difforder of the interval j
    maxdo = max(Adifforder,[],2); % maxdo(j) is the difforder of eqn j
    
    intnum = 1;    
    for jj = 1:syssize
        ii = brkidx{jj}; nii = numel(ii);
        % Separate out all the x's.
        for kk = 1:nii-1
            x{intnum} = y{jj}(ii(kk)+1:ii(kk+1));
            intnum = intnum + 1;
        end
        % Keep track of their sizes and difforder.
        idxj = intnum - (nii-1:-1:1);
        Nsys{jj} = cellfun(@numel,x(idxj));
        do(idxj) = max(Adifforder(jj,:));
    end
    N = cellfun(@length,x); % N is the number of pts on each interval.
    [Nsys{:}]
    
    % Shift the y values at the breakpoints. This is hacky...
    for jj = 1:syssize
        ii = brkidx{jj}; nii = numel(ii);
        for kk = 2:nii-1
            y{jj}(ii(kk)) = y{jj}(ii(kk)+1)-100*eps;
            y{jj}(ii(kk)+1) = y{jj}(ii(kk)+1)+100*eps;
        end
    end
    
    if sum(N) > maxdegree+1
      error('LINOP:mldivide:NoConverge',['Failed to converge with ',int2str(maxdegree+1),' points.'])
    elseif any(N==1)
      error('LINOP:mldivide:OnePoint',...
        'Solution requested at a lone point. Check for a bug in the linop definition.')
    elseif any(N(:) <= do(:)+1)
      % Too few points: force refinement
      jj = find(N(:) <= do(:)+1);
      v = x;
      % THIS NEEDS TWEAKING FOR BREAKPOINTS
      for kk = 1:length(jj)
          v{jj(kk)} = ones(N(jj(kk)),1); 
          v{jj(kk)}(2:2:end) = -1;
      end
      return
    end    
    
    % Boundary conditions
    [Bmat b] = bdyreplace_sys(A,Nsys,map,breaks);   % Get the replacement rows
    
    numbcs = sum(cellfun(@numel,Nsys).*maxdo)-size(Bmat,1); % # of cty bcs.
    Cmat = zeros(numbcs,sum(N));        % Continuituty bcs for pw intervals.    
    bcrownum = 1; intnum = 1; csN = cumsum([0 N]);  
    % Apply continuity conditions for piecewise intervals
    for kk = 1:syssize
        dok = max(Adifforder(:,kk));    % Difforder for this equation
        numfunsk = numel(breaks{kk})-1; % # of intervals in this variable
        if numfunsk > 1
            Nsysk = Nsys{kk};           % # of points in each interval
            % Make the differentiation matrices for piecewise boundary conditions.
            if dok > 1
                D = zeros(sum(Nsysk),sum(Nsysk),dok-1);
                bkk = breaks{kk}([1 end]);
                D(:,:,1) = feval(diff(domain(bkk)),Nsysk,[],breaks{kk});
                for ll = 2:dok-1
                  D(:,:,ll) = D(:,:,1)*D(:,:,ll-1);
                end
            end

            csNsysk = cumsum([0 Nsysk]);
            % Extract the right rows
            for jj = 1:numfunsk-1
                % Continuity condition
                Cmat(bcrownum,csN(intnum)+Nsysk(jj)+(0:1)) = [-1 1];
                bcrownum = bcrownum + 1;
                % Derivative conditions
                indxl = csNsysk(jj)+(1:Nsysk(jj));
                indxr = csNsysk(jj+1)+(1:Nsysk(jj+1));
                len = indxr(end)-indxl(1)+1;
                for ll = 1:dok-1   
                    Dl = D(csNsysk(jj+1),indxl,ll);
                    Dr = D(csNsysk(jj+1)+1,indxr,ll);
                    Cmat(bcrownum,csN(intnum)+(1:len)) = [-Dl Dr];
                    bcrownum = bcrownum + 1;
                end
                intnum = intnum + 1;
            end
            intnum = intnum + 1;
        else
            intnum = intnum + 1;
        end
    end
    c = zeros(size(Cmat,1),1); % RHS of continuity conditions
        
   
    % Construct the block entries of the main matrix
    Ajk = cell(syssize);
    for kk = 1:syssize
        Nsysk = Nsys{kk}; sNsysk = sum(Nsysk);
        Akfull = feval(A,Nsysk,map,breaks{kk});
        blockcolindx = (kk-1)*sNsysk+1:kk*sNsysk;
        Ablockcol = Akfull(:,blockcolindx);
        for jj = 1:syssize
            blockrowindx = (jj-1)*sNsysk+1:jj*sNsysk;
            Ajk{jj,kk} = Ablockcol(blockrowindx,:);
        end
    end
           
%    % Assemble the main matrix and rhs
%     Amat = []; f = [];
%     for jj = 1:syssize
%         Amatj = [];
%         Nsysj = Nsys{jj};
% %         newN = Nsysj;
%         newN = Nsysj - maxdo(jj);
% %             newN = Nsysj; newN(1) = newN(1) - maxdo(jj);
%         for kk = 1:syssize
%             P = barymatp(newN,breaks{jj},Nsys{kk},breaks{kk});
%             Amatj = [Amatj P*Ajk{jj,kk}];
%             if jj == kk
%                 f = [f ; P*B(y{jj},jj)]; % The RHS
%             end
%         end    
%         Amat = [Amat ; Amatj];
% %         y{jj}
%     end  
    
    %%%%%%% testing linear row dependence removal %%%%%%%

%     Emat = [];
%     for jj = 1:syssize
%         Ematj = [];
%         Nsysj = Nsys{jj};
%         newN = 0*Nsysj+2;
%         for kk = 1:syssize
%             P = barymatp(newN,breaks{jj},Nsys{kk},breaks{kk});
%             Ematj = [Ematj P*Ajk{jj,kk}];
%         end    
%         Emat = [Emat ; Ematj];
%     end 
%     
%     Fmat = [Bmat ; Cmat];
%     rowidx = zeros(2,nfuns);
%     for kk = 1:2*nfuns
%         Fmat = [Fmat ; Emat(kk,:)];
%         if rank(Fmat) < size(Fmat,1);
%             Fmat(end,:) = [];
%             rowidx(kk) = 1;
%         end
%     end
%     rowidx;
%     rowidx = mat2cell(rowidx',cellfun(@numel,Nsys),2);
%        
%     % Assemble the main matrix and rhs
%     Amat = []; f = [];
%     for jj = 1:syssize
%         Amatj = [];
%         Nsysj = Nsys{jj};
%         rjj = rowidx{jj};
%         newN = Nsysj - maxdo(jj)*(~sum(rjj,2)).';
% %             newN = Nsysj; newN(1) = newN(1) - maxdo(jj);
%         for kk = 1:syssize
%             P = barymatp(newN,breaks{jj},Nsys{kk},breaks{kk});
%             Amatj = [Amatj P*Ajk{jj,kk}];
%             if jj == kk
%                 fj = P*B(y{jj},jj); % The RHS
%             end
%         end  
%         rjj = 1./rjj-1;
%         cN = cumsum([0 newN]).';
%         rjj(:,1) = rjj(:,1)+cN(1:end-1)+1;
%         rjj(:,2) = rjj(:,2)+cN(2:end);
%         rjj = rjj(:);
%         rjj(isinf(rjj)) = [];
%         
%         Amatj(rjj,:) = [];
%         fj(rjj) = [];
%         f = [f ; fj];
%         Amat = [Amat ; Amatj];
%     end  
       
    %%%%%% testing linear row dependence removal %%%%%%%
    
%     %%%%%%%% testing linear row dependence removal %%%%%%%
% 
%     Emat = [];
%     for jj = 1:syssize
%         Ematj = [];
%         Nsysj = Nsys{jj};
%         newN = 0*Nsysj+2;
%         for kk = 1:syssize
%             P = barymatp(newN,breaks{jj},Nsys{kk},breaks{kk});
%             Ematj = [Ematj P*Ajk{jj,kk}];
%         end    
%         Emat = [Emat ; Ematj];
%     end 
%     
%     Fmat = Bmat;
%     rowidx = zeros(2,nfuns);
%     for kk = 1:2*nfuns
%         Fmat = [Fmat ; Emat(kk,:)];
%         if rank(Fmat) < size(Fmat,1);
%             Fmat(end,:) = [];
%             rowidx(kk) = 1;
%         end
%     end
%     sr = sum(rowidx(:));
%     rowidx = mat2cell(rowidx',cellfun(@numel,Nsys),2);
%     
%     rowidx2 = false(size(Cmat,1),1);
%     for kk = 1:size(Cmat,1);
%         Fmat = [Fmat ; Cmat(kk,:)];
%         if rank(Fmat) < size(Fmat,1);
%             Fmat(end,:) = [];
%             rowidx2(kk) = true;
%         end
%     end
%     Cmat(rowidx2,:) = [];
%     c(rowidx2,:) = [];
%     
%     numtrims = size(Bmat,1) + size(Cmat,1) - sr;
%     newN = cell(syssize,1);
%     for jj = 1:syssize
%         newN{jj} = Nsys{jj} - maxdo(jj)*(~sum(rowidx{jj},2)).';
%     end
%     addback = sum(N) - sum([newN{:}]) - numtrims
%     jj = 1; newnewN = [newN{:}];
%     while addback > 0
%         newnewN(jj) = newnewN(jj)+1;
%         jj = jj + 1;
%         addback = addback - 1;
%         if jj > numel(newnewN), jj = 1; end
%     end
%     newN = mat2cell(newnewN,1,cellfun(@numel,breaks)-1);
%     [newN{:}]
%     
% %     tmp = [Emat ; Bmat ; Cmat];
% %     st = size(tmp)
% %     rt = rank(tmp)
%         
%     
%     % Assemble the main matrix and rhs
%     Amat = []; f = [];
%     for jj = 1:syssize
%         Amatj = [];
%         Nsysj = Nsys{jj};
%         rjj = rowidx{jj};
% %         mdoj = maxdo(jj);
% %         maxdo(jj)*(~sum(rjj,2)).';
% %         newN = Nsysj - maxdo(jj)*(~sum(rjj,2)).'
% %             newN = Nsysj; newN(1) = newN(1) - maxdo(jj);
%         for kk = 1:syssize
%             P = barymatp(newN{jj},breaks{jj},Nsys{kk},breaks{kk});
%             Amatj = [Amatj P*Ajk{jj,kk}];
%             if jj == kk
%                 fj = P*B(y{jj},jj); % The RHS
%             end
%         end  
%         rjj = 1./rjj-1;
%         cN = cumsum([0 newN{jj}]).';
%         rjj(:,1) = rjj(:,1)+cN(1:end-1)+1;
%         rjj(:,2) = rjj(:,2)+cN(2:end);
%         rjj = rjj(:);
%         rjj(isinf(rjj)) = [];
%         
%         Amatj(rjj,:) = [];
%         fj(rjj) = [];
%         f = [f ; fj];
%         Amat = [Amat ; Amatj];
%     end  
%        
%     %%%%%%% testing linear row dependence removal %%%%%%% 

    %%%%%%%% testing linear row dependence removal %%%%%%%

    Emat = [];
    for jj = 1:syssize
        Ematj = [];
        Nsysj = Nsys{jj};
        newN = 0*Nsysj+2;
        for kk = 1:syssize
            P = barymatp(newN,breaks{jj},Nsys{kk},breaks{kk});
            Ematj = [Ematj P*Ajk{jj,kk}];
        end    
        Emat = [Emat ; Ematj];
    end 

    Fmat = [Bmat ; Cmat];
    rowidx = zeros(2,nfuns);
    for kk = 1:2*nfuns
        Fmat = [Fmat ; Emat(kk,:)];
        if rank(Fmat) < size(Fmat,1);
            Fmat(end,:) = [];
            rowidx(kk) = 1;
        end
    end
    sr = sum(rowidx).';
    rowidx = mat2cell(rowidx',cellfun(@numel,Nsys),2);

    N;
    newN = N - do' + sr';
    snN = sum(newN);
    sN = sum(N);
    
    numbcs = size([Bmat ; Cmat],1);
    
    mydiff = sum(N) - sum(newN) + sum(sr) - size([Bmat ; Cmat],1);

    while mydiff < 0 
        [dN ii] = max(newN-N);
        if dN >= 0
            mydiff = mydiff + 1;
            newN(ii) = newN(ii) - 1;
        else
            error
        end
    end
    while mydiff > 0 
        [dN ii] = min(newN-N);
        if dN <= 0
            mydiff = mydiff - 1;
            newN(ii) = newN(ii) + 1;
        else
            error
        end
    end
%     N
%     newN
%     newN - sr'
%     sum(ans)+size([Bmat ; Cmat],1)
%     sum(N)
%     
    newN = mat2cell(newN,1,cellfun(@numel,breaks)-1);
    
    % Assemble the main matrix and rhs
    Amat = []; f = [];
    for jj = 1:syssize
        Amatj = [];
        Nsysj = Nsys{jj};
        rjj = rowidx{jj};
        for kk = 1:syssize
            P = barymatp(newN{jj},breaks{jj},Nsys{kk},breaks{kk});
            Amatj = [Amatj P*Ajk{jj,kk}];
            if jj == kk
                fj = P*B(y{jj},jj); % The RHS
            end
        end  
        
        rjj = 1./rjj-1;
        cN = cumsum([0 newN{jj}]).';
        rjj(:,1) = rjj(:,1)+cN(1:end-1)+1;
        rjj(:,2) = rjj(:,2)+cN(2:end);
        rjj = rjj(:);
        rjj(isinf(rjj)) = [];
        
        Amatj(rjj,:) = [];
        fj(rjj) = [];

        f = [f ; fj];
        Amat = [Amat ; Amatj];
        
    end 
%  
%     
%     %%%%%%% testing linear row dependence removal %%%%%%% 
    
    Amat = [Amat ; Bmat ; Cmat];  % Augment the boundary conditions to A.
    f = [f ; b ; c];              % And the rhs.
    
%     sABC = size(Amat)
%     rABC = rank(Amat)
    
    
    v = Amat\f;             % Solve the system
    v = mat2cell(v,N,1);    % Reshape and convert to cell array
    
    % Filter
    u = [];
    figure(1); hold off
    for kk = 1:numel(v)
        v{kk} = filter(v{kk},1e-8);
        u = [u ; v{kk}];
    end
    
    % Store here for output
    V = v;
    
%     if rABC < sABC(1), error, end
    
%     tmp = chebfun;
%     for kk = 1:numel(v)
%         tmp = [tmp chebfun(v{kk})];
%     end
%     chebpolyplot(tmp)
% %     plot(tmp)
%     pause

    % Reshape and convert to cell array of the right size
    v = mat2cell(u(:),cellfun(@length,y),1);    

  end

end

function [breaks ii] = findbreaks(y)
dy = diff(y);
ii = [1 ; find(~dy) ; length(y)];
breaks = y(ii).';
ii(1) = 0;
end